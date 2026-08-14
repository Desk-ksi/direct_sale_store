// JSの読み込みが、ページのbodyよりも上にあるためdocument.addEventListener("DOMContentLoaded"を入れないと、要素を見つけられない
document.addEventListener("DOMContentLoaded", function() {
  const locationGetButton = document.getElementById('get-location-btn');
  const latitudeGotText = document.getElementById('shop_latitude');
  const longitudeGotText = document.getElementById('shop_longitude');
  const locationGotStatus = document.getElementById('location-btn-label');
  if (locationGetButton) {
    locationGetButton.addEventListener('click', function() {
      navigator.geolocation.getCurrentPosition(function(position) {
        // 入力フィールドの値を変えるときは、valueを指定
        latitudeGotText.value = position.coords.latitude;
        longitudeGotText.value = position.coords.longitude;
        console.log(position.coords.latitude);
        console.log(position.coords.longitude);
        locationGotStatus.textContent = "店の場所を特定しました"
        console.log(locationGotStatus);
      })
    })
  }
});

document.addEventListener("DOMContentLoaded", function() {
  const imageShopPhoto = document.getElementById('photo-preview-img');
  const imageShopFiled = document.getElementById('shop_image');
  const imageShopLabel = document.getElementById('photo-upload-label');
  if (imageShopPhoto) {
    imageShopFiled.addEventListener('change', function() {
      const file = imageShopFiled.files[0];
      const reader = new FileReader();
      reader.onload = function() {
        imageShopPhoto.src = reader.result;
        imageShopPhoto.classList.remove('d-none');
        imageShopLabel.textContent = "変更する場合は再度押してください"
      };
      reader.readAsDataURL(file);
    });
  }
});