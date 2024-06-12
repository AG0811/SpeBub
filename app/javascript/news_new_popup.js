console.log('news_new_popup.jsを読み込みました')
document.addEventListener('DOMContentLoaded', function() {
  const postLink = document.querySelector('.post');
  const formPopup = document.querySelector('.form-popup');
  const overlay = document.createElement('div');
  overlay.className = 'overlay';
  document.body.appendChild(overlay);

  if (postLink && formPopup) {
    postLink.addEventListener('click', function(event) {
      event.preventDefault();
      formPopup.classList.add('active');
      overlay.classList.add('active');
    });

    // Popup外をクリックした際にPopupを非表示にする
    overlay.addEventListener('click', function() {
      formPopup.classList.remove('active');
      overlay.classList.remove('active');
    });

    // Popup内のクリックイベントを無視
    formPopup.addEventListener('click', function(event) {
      event.stopPropagation();
    });
  }
});
