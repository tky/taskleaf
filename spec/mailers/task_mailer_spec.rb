require 'rails_helper'

describe TaskMailer, type: :mailer do
  let(:task) { FactoryBot.create(:task, name: 'specを書く', description: 'メール内容を確認') }

  describe '#creation_email' do
    let(:mail) { TaskMailer.creation_email(task) }

    it 'works' do
      expect(mail.subject).to eq('タスク作成完了メール')
    end
  end
end
