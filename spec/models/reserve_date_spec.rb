require 'rails_helper'

RSpec.describe ReserveDate, type: :model do
  describe "#entry!" do
    subject { reserve_date.entry! }
    let(:reserve_date) { create(:reserve_date, entry_flg: entry_flg, start_date: start_date, end_date: end_date)}
    let(:start_date) { Date.today.next }
    let(:end_date) { start_date.next.next }
    context "すでに承認済みの場合" do
      let(:entry_flg) { "entry_status" }
      it "例外が発生する" do
        expect { subject }.to raise_error(ReserveStatusError)
      end
    end
    context "すでに承認済みではない場合" do
      let(:entry_flg) { "no_entry_status"}
      before do
        allow(ReserveCount).to receive(:reserve!).with(reserve_date.oaccount, start_date)
        allow(ReserveCount).to receive(:reserve!).with(reserve_date.oaccount, start_date.next)
        allow(ReserveCount).to receive(:reserve!).with(reserve_date.oaccount, end_date)
      end
      it "承認済みになる" do
        subject
        expect(reserve_date.entry_flg).to eq "entry_status"
      end
      it "該当日の空きベッド数が減る" do
        subject
        expect(ReserveCount).to have_received(:reserve!).with(reserve_date.oaccount, start_date).once
        expect(ReserveCount).to have_received(:reserve!).with(reserve_date.oaccount, start_date.next).once
        expect(ReserveCount).not_to have_received(:reserve!).with(reserve_date.oaccount, end_date)
      end
    end
  end
 # -------cancel!--------実際のPGはデータを読み込む--------------------------------
  describe "#cancel!" do
    subject { reserve_date.cancel! }
    let(:reserve_date) { create(:reserve_date, entry_flg: entry_flg, start_date: start_date, end_date: end_date)}
    let(:start_date) { Date.today.next }
    let(:end_date) { start_date.next.next }
    context "すでに承認済みでない場合" do
      let(:entry_flg) { "no_entry_status" }
      it "例外が発生する" do
        expect { subject }.to raise_error(ReserveStatusError)
      end
    end
    context "すでに承認済みの場合" do
      let(:entry_flg) { "entry_status" }
      before do
        allow(ReserveCount).to receive(:cancel!).with(reserve_date.oaccount, start_date)
        allow(ReserveCount).to receive(:cancel!).with(reserve_date.oaccount, start_date.next)
        allow(ReserveCount).to receive(:cancel!).with(reserve_date.oaccount, end_date)
      end
      it "承認されていないに変更する" do
        subject
        expect(reserve_date.entry_flg).to eq "no_entry_status"
      end
      it "該当日の空きベッド数が増える" do
        subject
        expect(ReserveCount).to have_received(:cancel!).with(reserve_date.oaccount, start_date).once
        expect(ReserveCount).to have_received(:cancel!).with(reserve_date.oaccount, start_date.next).once
        expect(ReserveCount).not_to have_received(:cancel!).with(reserve_date.oaccount, end_date)
      end
    end

    context "保存が出来なかった場合" do
      let(:entry_flg) { "entry_status"}
      it "例外が発生する" do
        allow(reserve_date).to receive(:save!).and_raise(ActiveRecord::NotNullViolation)
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)

      end
    end
  end
# ---------------------------------------------------------


  describe "#reserve_end_date" do
    subject { reserve_date.reserve_end_date }
    let(:reserve_date) { create(:reserve_date, start_date: start_date, end_date: end_date)}
    let(:start_date) { Date.today.next }
    let(:end_date) { start_date.next.next }
    it "終了日の前日を返却する" do
      expect(subject).to eq end_date.ago(1.day).to_date
    end
  end
  describe "#display_user_name" do
    subject { reserve_date.display_user_name }
    let(:reserve_date) { create(:reserve_date, user_name: user_name ) }
    let(:user_name) { Faker::Name.name }
    context "uaccountがある場合" do
      let(:uaccount) { create(:uaccount) }
      before do
        reserve_date.update!(uaccount: uaccount)
      end
      it "uaccount.user_nameを返却する" do
        expect(subject).to eq uaccount.user_name
      end
    end
    context "uaccountがない場合" do
      it "user_nameを返却する" do
        expect(subject).to eq user_name
      end
    end
  end

  describe "#display_user_phone" do
    subject { reserve_date.display_user_phone }
    let(:reserve_date) {create(:reserve_date, user_phone: user_phone ) }
    let(:user_phone){ Faker::PhoneNumber.phone_number }
    context "uaccountがある場合" do
      let(:uaccount) { create(:uaccount) }
      before do
        reserve_date.update!(uaccount: uaccount)
      end
      it "uaccount.user_phoneを返却する" do
        expect(subject).to eq uaccount.user_phone
      end
    end
    context "uaccountがない場合" do
      it "user_phoneを返却する" do
        expect(subject).to eq user_phone
      end
    end
  end

  describe "#user_match?" do
    subject { reserve_date.user_match?(oaccount, uaccount)  }
    let(:reserve_date){ create(:reserve_date, office_id: oaccount_id, user_id: uaccount_id)}
    let(:oaccount_id){ origin_oaccount.id }
    let(:origin_oaccount){ create(:oaccount)}
    let(:uaccount_id){ create(:uaccount).id }
    context "uaccount.idとログインのuaccount.idが合っている場合" do
      let(:oaccount){ create(:oaccount) }
      let(:uaccount){ Uaccount.find_by(id: uaccount_id) }
      it { is_expected.to be true }

    end
    context "uaccount.idとログインのuaccount.idが違う場合" do
      let(:uaccount){ create(:uaccount) }
      context "oaccount.idとログインのoaccount.idが等しい場合" do
        let(:oaccount){ origin_oaccount}
        it { is_expected.to be true}
      end
      context "oaccount.idとログインのoaccount.idが等しくない場合" do
        let(:oaccount){ create(:oaccount) }
        it { is_expected.to be false}
      end
    end
    context "uaccount.id がnilのとき" do
      let(:uaccount_id){ nil }
      let(:uaccount){ create(:uaccount) }
      context "oaccount.idとログインのoaccount.idが等しい場合" do
        let(:oaccount){ origin_oaccount }
        it { is_expected.to be true}
      end
      context "oaccount.idとログインのoaccount.idが等しくない場合" do
        let(:oaccount){ create(:oaccount) }
        it { is_expected.to be false}
      end
    end
  end

  describe "#uaccount_comment_read" do
    subject { reserve_date.uaccount_comment_read }
    let(:reserve_date){ create(:reserve_date) }
    let!(:read_comment) do
      retval=reserve_date.comments.create
      allow(retval).to receive(:uaccount_comment_read?).and_return(true)
      allow(retval).to receive(:uaccount_comment_read)
      retval
    end
    let!(:unread_comment) do
      retval=reserve_date.comments.create
      allow(retval).to receive(:uaccount_comment_read?).and_return(false)
      allow(retval).to receive(:uaccount_comment_read)
      retval
    end
    it "未読コメントに既読をつける" do
      subject
      expect(unread_comment).to have_received(:uaccount_comment_read).once
    end
    it "既読コメントには既読をつけない" do
      subject
      expect(read_comment).not_to have_received(:uaccount_comment_read)
    end
  end

  describe "#oaccount_comment_read" do
    subject { reserve_date.oaccount_comment_read }
    let(:comment){ create(:comment, comment_id: comment_id, oaccount_read_at: oaccount_read_at ) }
    let(:comment_id){ 10 }
    context "oaccount_read_at がnilのとき" do
      let(:oaccount_read_at){ nil }
      it "oaccount_read_atが上書きされる" do
        expect(oaccount_read_at).to eq Comment.find_by(id: comment_id).oaccount_read_at
      end
      let(:oaccount_read_at){ Time.zone.now }
      it "oaccount_read_atが上書きされる" do
        expect(oaccount_read_at).to eq Comment.find_by(id: comment_id).oaccount_read_at
      end
    end
  end

end
