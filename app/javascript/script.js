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
  const imagePostPhoto = document.getElementById('post-photo-preview-img');
  const imagePostFiled = document.getElementById('post_image');
  const imagePostLabel = document.getElementById('post-photo-upload-label');
  if (imagePostPhoto) {
    imagePostFiled.addEventListener('change', function() {
      const file = imagePostFiled.files[0];
      const reader = new FileReader();
      reader.onload = function() {
        imagePostPhoto.src = reader.result;
        imagePostPhoto.classList.remove('d-none');
        imagePostLabel.textContent = "変更する場合は再度押してください"
      };
      reader.readAsDataURL(file);
    });
  }
});