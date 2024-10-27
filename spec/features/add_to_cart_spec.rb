require 'rails_helper'

RSpec.feature 'Add to Cart', type: :feature do
  let(:user) { create(:user) } # Ensure you have a user factory

  before do
    driven_by(:selenium_chrome) # Use Chrome for testing
    login_as(user) # Login helper method for Devise
    visit products_path # Change this to your products path
  end

  scenario 'User adds an item to the cart' do
    product = create(:product) # Ensure you have a product factory
    visit product_path(product)

    # Add item to cart
    click_button 'Add to Cart'

    # Check if cart updated
    expect(page).to have_content('Item has been added to your cart')
    expect(page).to have_selector('.cart-icon', text: '1') # Adjust selector to match your HTML
  end

  scenario 'User tries to add an out-of-stock item' do
    product = create(:product, stock: 0) # Create an out-of-stock product
    visit product_path(product)

    # Attempt to add out-of-stock item to cart
    click_button 'Add to Cart'

    # Check for alert message
    expect(page).to have_content('This item is out of stock')
  end

  scenario 'User cannot add item to cart without logging in' do
    # Log out the user
    logout

    product = create(:product)
    visit product_path(product)

    # Attempt to add item to cart
    click_button 'Add to Cart'

    # Check for login prompt
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
