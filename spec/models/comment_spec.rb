require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "#sender_user" do
    subject { comment.sender_user }
    let(:reserve_date) {create(:reserve_date)}
    let(:oaccount) {create(:oaccount)}
    let(:uaccount) {create(:uaccount)}
    let(:comment) { create(:comment, reserve_date_id: reserve_date.id, oaccount_id: oaccount.id, uaccount_id: uaccount.id, sender_flg: sender_flg)}
    context "oaccountの場合" do
      let(:sender_flg){ "oaccount_comment" }

      it "oaccountを返却する" do
        expect(subject).to eq oaccount
      end
    end
    context "uaccountの場合" do
      let(:sender_flg){ "uaccount_comment" }
      it "uaccount_idを返却する" do
        expect(subject).to eq uaccount
      end
    end
  end
  describe "#sender_user_match?" do
    subject { comment.sender_user_match?(oaccount_find, uaccount_find) }
    let(:reserve_date) {create(:reserve_date)}
    let(:oaccount) {create(:oaccount)}
    let(:uaccount) {create(:uaccount)}
    let(:uaccount_find) {create(:uaccount)}
    let(:oaccount_find) {create(:oaccount)}
    let(:comment) { create(:comment, reserve_date_id: reserve_date.id, oaccount_id: oaccount.id, uaccount_id: uaccount.id, sender_flg: sender_flg)}
    context "oaccountが作成したコメントの場合" do
      let(:sender_flg){ "oaccount_comment"}
      context "引数に指定したoaccountが送信者と等しい場合" do
        let(:oaccount_find){oaccount}
        it { is_expected.to be true }
      end
      context "引数に指定したoaccountが送信者と異なる場合" do
        it { is_expected.to be false }
      end
    end
    context "uaccountが作成したコメントの場合" do
      let(:sender_flg){ "uaccount_comment"}
      context "引数に指定したuaccountが送信者と等しい場合" do
        let(:uaccount_find){uaccount}
        it { is_expected.to be true }
      end
      context "引数に指定したuaccountが送信者と異なる場合" do
        it { is_expected.to be false }
      end
    end
  end

  describe "#uaccount_comment_read?" do
    subject { comment.uaccount_comment_read? }
    let(:reserve_date){create(:reserve_date)}
    let(:comment){ create(:comment, uaccount_read_at: read_at, sender_flg: "uaccount_comment", reserve_date_id: reserve_date.id)}
    context "read_atが存在するとき" do
      let(:read_at){ Date.today }
      it { is_expected.to be true }
    end
    context "read_atがnilのとき" do
      let(:read_at){ nil }
      it { is_expected.to be false }
    end
  end


  describe "#uaccount_comment_read" do
    subject { comment.uaccount_comment_read }
    let(:reserve_date){create(:reserve_date)}
    let(:comment){ create(:comment, uaccount_read_at: read_at, sender_flg: "uaccount_comment", reserve_date_id: reserve_date.id)}
    context "既読のとき" do
      let(:read_at){ Time.zone.now.ago(1.year) }
      it "comment_read_atが更新されない" do
        subject
        expect(comment.reload.uaccount_read_at.strftime("%F %T")).to eq read_at.strftime("%F %T")
      end
    end
    context "未読のとき" do
      before do
        time = Time.zone.now
        allow(Time.zone).to receive(:now).and_return(time)
      end
      let(:read_at){ nil }
      it "comment_read_atが更新されない" do
        subject
        expect(comment.reload.uaccount_read_at.strftime("%F %T")).to eq Time.zone.now.strftime("%F %T")
      end

    end

  end
  describe "#oaccount_comment_read?" do
    subject { comment.oaccount_comment_read? }
    let(:reserve_date){create(:reserve_date)}
    let(:comment){ create(:comment, oaccount_read_at: read_at, sender_flg: "oaccount_comment", reserve_date_id: reserve_date.id)}
    context "read_atが存在するとき" do
      let(:read_at){ Date.today }
      it { is_expected.to be true }
    end
    context "read_atがnilのとき" do
      let(:read_at){ nil }
      it { is_expected.to be false }
    end
  end


  describe "#oaccount_comment_read" do
    subject { comment.oaccount_comment_read }
    let(:reserve_date){create(:reserve_date)}
    let(:comment){ create(:comment, oaccount_read_at: read_at, sender_flg: "oaccount_comment", reserve_date_id: reserve_date.id)}
    context "既読のとき" do
      let(:read_at){ Time.zone.now.ago(1.year) }
      it "comment_read_atが更新されない" do
        subject
        expect(comment.reload.oaccount_read_at.strftime("%F %T")).to eq read_at.strftime("%F %T")
      end
    end
    context "未読のとき" do
      before do
        time = Time.zone.now
        allow(Time.zone).to receive(:now).and_return(time)
      end
      let(:read_at){ nil }
      it "comment_read_atが更新される" do
        subject
        expect(comment.reload.oaccount_read_at.strftime("%F %T")).to eq Time.zone.now.strftime("%F %T")
      end
    end
  end
  describe "#delete" do
    subject { comment.delete }
    let(:reserve_date){create(:reserve_date)}
    let(:comment){ create(:comment, deleted_at: nil, sender_flg: "oaccount_comment", reserve_date_id: reserve_date.id)}
    before do
      time = Time.zone.now
      allow(Time.zone).to receive(:now).and_return(time)
    end
    it "deleted_atが更新される" do
      subject
      expect(comment.reload.deleted_at.strftime("%F %T")).to eq Time.zone.now.strftime("%F %T")
    end
  end

end
