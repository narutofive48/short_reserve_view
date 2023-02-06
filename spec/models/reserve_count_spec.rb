require 'rails_helper'

RSpec.describe ReserveCount, type: :model do
  describe ".reserve!" do
    subject { ReserveCount.reserve!(oaccount,date) }
    let(:oaccount) { create(:oaccount)}
    let(:date) { Date.today.next }
    context "すでにレコードがある場合" do
      let!(:reserve_count) { create(:reserve_count, oaccount_id: oaccount.id, date: date, last_count: last_count) }
      let(:last_count) { 10 }
      it "reserve_countに保存されているベッド数から1引いた数が保存される" do
        subject
        data_last_count = reserve_count.reload.last_count
        expect(data_last_count).to eq last_count - 1
      end
    end

    context "レコードがない場合" do
      it "事業所のbed_countの数字から1引いた数を保存する" do
        subject
        last_count=ReserveCount.find_by(oaccount_id: oaccount.id, date: date).last_count
        expect(last_count).to eq oaccount.office_bed_count - 1
      end
    end


#  itemのreserveが呼び出される　
    context "すでにレコードがある場合" do
      let(:reserve_count) { create(:reserve_count, oaccount_id: oaccount.id, date: date, last_count: last_count) }
      let(:last_count) { 10 }
      before do
        allow(ReserveCount).to receive(:find_or_initialize_by).with(oaccount_id: reserve_count.oaccount_id, date: reserve_count.date).and_return(reserve_count)
        allow(reserve_count).to receive(:reserve!)
      end
      it "reserveが呼び出される" do
        subject
        expect(reserve_count).to have_received(:reserve!).once
      end
    end
#  itemのreserveが呼び出される レコードが作成される
    context "レコードがない場合" do
      let(:reserve_count) { build(:reserve_count, oaccount_id: oaccount.id, date: date) }
      let(:last_count) { 10 }
      before do
        allow(ReserveCount).to receive(:find_or_initialize_by).with(oaccount_id: reserve_count.oaccount_id, date: reserve_count.date).and_return(reserve_count)
      end
      it "reserveが呼び出される" do
        allow(reserve_count).to receive(:reserve!)
        subject
        expect(reserve_count).to have_received(:reserve!).once
      end
      it "saveが呼び出される" do
        allow(reserve_count).to receive(:save!)
        subject
        expect(reserve_count).to have_received(:save!).once
      end
    end


  end


  describe "#reserve!" do
    subject { reserve_count.reserve! }
    let(:reserve_count) { create(:reserve_count, last_count: last_count, oaccount_id: oaccount.id )}
    let(:oaccount) { create(:oaccount)}
    context "空室がある場合" do
      let(:last_count) { 10 }
      it "last_count から　1　引く" do
        subject
        expect(reserve_count.last_count).to eq last_count - 1
      end
    end
    context "空室がない場合" do
      let(:last_count) { 0 }
      it "例外が発生する" do
        expect { subject }.to raise_error( ShortageBedError )
      end
      it "last_count 変化しない" do
        begin
          subject
        rescue
        end
        expect( reserve_count.last_count).to eq last_count
      end
    end

  end


  describe ".cancel!" do
    subject { ReserveCount.cancel!(oaccount,date) }
    let(:oaccount) { create(:oaccount) }
    let(:date) { Date.today.next }
    before do
      allow(ReserveCount).to receive(:find_by).with(oaccount_id: oaccount.id, date: date).and_return(reserve_count)
    end
    context "予約データがある場合" do
      let(:reserve_count) { create(:reserve_count, oaccount_id: oaccount.id, date: date, last_count: last_count) }
      let(:last_count) { 10 }
      before do
        allow(reserve_count).to receive(:cancel!)
      end
      it "cancel!が呼び出される" do
        subject
        expect(reserve_count).to have_received(:cancel!).once
      end
    end
    context "予約データがない場合" do
      let(:reserve_count) { nil }
      it "例外が発生する" do
        expect { subject }.to raise_error( StandardError)
      end
    end
  end
  describe "#cancel!" do
    subject { reserve_count.cancel! }
    let(:reserve_count) { create(:reserve_count, oaccount_id: oaccount.id, date: date, last_count: last_count)}
    let(:oaccount) { create(:oaccount) }
    let(:date) { Date.today.next }
    let(:last_count) { 10 }
    it "last_countが 1 増える" do
      subject
      expect(reserve_count.last_count).to eq last_count + 1
    end
  end
end
