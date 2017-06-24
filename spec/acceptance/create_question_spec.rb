require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question with valid attributes' do
    sign_in(user)

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content I18n.t('questions.create.created')

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user create the question with invalid attributes' do
    sign_in(user)

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user ties to create question' do

    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
