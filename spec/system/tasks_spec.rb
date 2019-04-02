require 'rails_helper'

describe 'タスク管理機能', type: :system do

  let(:user_a) { FactoryBot.create(:user, name: 'ユーザA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザB', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザAが作成したタスクが評される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザAがログインしている' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザAが作成したタスクが評される'
    end

    context 'ユーザBがログインしている' do
      let(:login_user) { user_b }

      it 'ユーザAが作成したタスクが表示されない' do
        expect(page).not_to have_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザAがログインしている' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザAが作成したタスクが評される'
    end
  end

  describe '新規作成' do
    let(:login_user) { user_a }

    before do
      visit new_task_path
      fill_in '名前', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力' do
      let(:task_name) { '新規テスト作成' }
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規テスト作成'
      end
    end

    context '名称を入力しなかった場合' do
      let(:task_name) { '' }

      it ' エラー' do
        within '#error_explanation' do
          expect(page).to have_content '名前を入力してください'
        end
      end
    end
  end
end
