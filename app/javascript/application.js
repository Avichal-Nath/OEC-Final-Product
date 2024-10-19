// app/javascript/packs/application.js

import Rails from "@rails/ujs";  // Add this to ensure Rails UJS works
Rails.start();

import "@hotwired/turbo-rails";
import "controllers";

// Add variant handling, filtering, and preview logic

document.addEventListener('DOMContentLoaded', () => {
  const addVariantButton = document.getElementById('add-variant');
  const variantsContainer = document.getElementById('variants-container').querySelector('tbody');
  const variantTemplate = document.getElementById('variant-template').innerHTML;

  // Function to add a new variant field
  const addVariantField = () => {
    const index = variantsContainer.querySelectorAll('.variant-fields').length;
    const newVariantFields = variantTemplate.replace(/__index__/g, index);
    variantsContainer.insertAdjacentHTML('beforeend', newVariantFields);
    updateEventListeners();
    updateProductPreview();
  };

  // Function to update the product preview card
  const updateProductPreview = () => {
    const name = document.querySelector('input[name="product[name]"]').value;
    const description = document.querySelector('textarea[name="product[description]"]').value;
    const price = document.querySelector('input[name="product[price]"]').value;
    const image = document.querySelector('input[name="product[image]"]').files[0];
    const previewImage = document.querySelector('.card-img-top');
    const previewTitle = document.querySelector('.card-title');
    const previewText = document.querySelector('.card-text');

    if (image) {
      const reader = new FileReader();
      reader.onload = function(e) {
        previewImage.src = e.target.result;
      };
      reader.readAsDataURL(image);
    } else {
      previewImage.src = ''; // Clear the image preview if no image is selected
    }

    previewTitle.textContent = name || 'Product Name';
    previewText.innerHTML = `<p>${description || 'Product description goes here.'}</p><p><strong>Price: $</strong> ${price || '0.00'}</p>`;

    const variantsPreviewContainer = document.querySelector('.variants');
    variantsPreviewContainer.innerHTML = '';

    document.querySelectorAll('.variant-fields').forEach(row => {
      const color = row.querySelector('input[name*="[color]"]').value;
      const size = row.querySelector('input[name*="[size]"]').value;
      const quantity = row.querySelector('input[name*="[quantity]"]').value;

      variantsPreviewContainer.innerHTML += `
        <div class="variant">
          <p><strong>Color:</strong> ${color}</p>
          <p><strong>Size:</strong> ${size}</p>
          <p><strong>Quantity:</strong> ${quantity}</p>
        </div>
      `;
    });
  };

  // Function to update event listeners on dynamic elements
  const updateEventListeners = () => {
    variantsContainer.querySelectorAll('.remove-variant').forEach(button => {
      button.addEventListener('click', () => {
        button.closest('.variant-fields').remove();
        updateProductPreview();
      });
    });

    document.querySelectorAll('input[name="product[name]"], textarea[name="product[description]"], input[name="product[price]"], input[name="product[image]"]').forEach(input => {
      input.addEventListener('input', updateProductPreview);
    });
  };

  // Initial setup
  addVariantButton.addEventListener('click', addVariantField);
  updateEventListeners();
  updateProductPreview();
});

document.addEventListener("DOMContentLoaded", function() {
  const filterForm = document.getElementById('filter-form');

  filterForm.addEventListener('submit', function(event) {
    event.preventDefault();
    
    const formData = new FormData(filterForm);
    
    fetch(filterForm.action, {
      method: 'GET',
      body: formData,
      headers: {
        'Accept': 'application/javascript'
      }
    })
    .then(response => response.text())
    .then(data => {
      document.getElementById('products-list').innerHTML = data;
    });
  });
});
