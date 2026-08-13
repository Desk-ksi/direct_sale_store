// JSの読み込みが、ページのbodyよりも上にあるためdocument.addEventListener("DOMContentLoaded"を入れないと、要素を見つけられない
document.addEventListener("DOMContentLoaded", function() {
  const locationGetButton = document.getElementById('get-location-btn');
  const latitudeGotText = document.getElementById('shop_latitude')
  const longitudeGotText = document.getElementById('shop_longitude')
  if (locationGetButton) {
    locationGetButton.addEventListener('click', function() {
      navigator.geolocation.getCurrentPosition(function(position) {
        // 入力フィールドの値を変えるときは、valueを指定
        latitudeGotText.value = position.coords.latitude;
        longitudeGotText.value = position.coords.longitude;
      })
    })
  }
});