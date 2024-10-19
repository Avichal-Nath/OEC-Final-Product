document.addEventListener('DOMContentLoaded', () => {
    const addButton = document.querySelector('#add_variant');
    const variantsContainer = document.querySelector('#variants_container');
    let index = variantsContainer.dataset.index || 0;
  
    addButton.addEventListener('click', () => {
      index++;
      const newVariant = document.createElement('div');
      newVariant.innerHTML = `
        <div class="form-group">
          <label for="product_variants_attributes_${index}_color" class="control-label col-sm-2">Color</label>
          <div class="col-sm-10">
            <input class="form-control" type="text" name="product[variants_attributes][${index}][color]" id="product_variants_attributes_${index}_color">
          </div>
        </div>
        <div class="form-group">
          <label for="product_variants_attributes_${index}_size" class="control-label col-sm-2">Size</label>
          <div class="col-sm-10">
            <input class="form-control" type="text" name="product[variants_attributes][${index}][size]" id="product_variants_attributes_${index}_size">
          </div>
        </div>
        <div class="form-group">
          <label for="product_variants_attributes_${index}_quantity" class="control-label col-sm-2">Quantity</label>
          <div class="col-sm-10">
            <input class="form-control" type="number" name="product[variants_attributes][${index}][quantity]" id="product_variants_attributes_${index}_quantity">
          </div>
        </div>
      `;
      variantsContainer.appendChild(newVariant);
      variantsContainer.dataset.index = index;
    });
  });
  