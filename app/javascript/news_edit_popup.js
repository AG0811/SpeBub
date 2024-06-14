document.addEventListener('turbo:load', function() {
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
      })
      .catch(error => console.error('Error fetching edit form:', error));
    });
  });

  overlay.addEventListener('click', () => {
    overlay.style.display = 'none';
    popup.style.display = 'none';
  });

  newsItems.forEach(item => {
    item.addEventListener('click', (event) => {
      const clickedElement = event.target;

      if (!clickedElement.classList.contains('edit-link') && !clickedElement.classList.contains('more_list') && !clickedElement.classList.contains('more')) {
        const newsId = item.dataset.newsId;
        window.location.href = '/news/' + newsId;
      }
    });
  });
});