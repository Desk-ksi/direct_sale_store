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

// 現在地を取得して、現在地をパラメーターにしてindex_distance_shops_pathに送る
document.addEventListener("DOMContentLoaded", function() {
  const distanceGetButton = document.getElementById('search-location-btn');
  if (distanceGetButton) {
    distanceGetButton.addEventListener('click', function() {
      navigator.geolocation.getCurrentPosition(function(position) {
        const paramsCurrentLatitude = position.coords.latitude;
        const paramsCurrentLongitude = position.coords.longitude;
        console.log(position.coords.latitude);
        console.log(position.coords.longitude);
        // window.location.hrefにURLを渡すことで、画面遷移が可能
        // パラメーターとは、URLに載って、遷移先に送られる
        // 「?」はURLのルールでこの先はパラメーターですよと明示している
        // URLに載せられるのは、文字列のみ。緯度経度は変数に入っているため、JSの書き方である「${変数}」で文字列に直している
        // これで遷移先のコントローラーで「current_latitude」「current_longitude」というパラメーターが使える
        window.location.href = `/shops/index_distance?current_latitude=${paramsCurrentLatitude}&current_longitude=${paramsCurrentLongitude}`
      })
    })
  }
});