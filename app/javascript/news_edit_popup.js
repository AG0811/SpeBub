console.log('news_edit_popup.jsを読み込みました')
document.addEventListener('DOMContentLoaded', () => {
  const editButtons = document.querySelectorAll('.edit-link');
  const overlay = document.querySelector('.overlay');
  const popup = document.querySelector('.edit-form-popup');
  const newsItems = document.querySelectorAll('.news-item');

  editButtons.forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const url = button.getAttribute('href');
      fetch(url, {
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => response.text())
      .then(data => {
        popup.innerHTML = data;
        overlay.style.display = 'block';
        popup.style.display = 'block';
      });
    });
  });

  overlay.addEventListener('click', () => {
    overlay.style.display = 'none';
    popup.style.display = 'none';
  });

  newsItems.forEach(item => {
    item.addEventListener('click', (event) => {
      const clickedElement = event.target;

      // クリックした要素がボタンでない場合のみ詳細ページに遷移
      if (!clickedElement.classList.contains('edit-link') && !clickedElement.classList.contains('more_list') && !clickedElement.classList.contains('more')) {
        const newsId = item.dataset.newsId;
        window.location.href = '/news/' + newsId;
      }
    });
  });
});
