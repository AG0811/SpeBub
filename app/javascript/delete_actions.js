document.addEventListener('turbo:load', function() {
  const deleteButtons = document.querySelectorAll('form.button_to button');

  deleteButtons.forEach(button => {
    button.addEventListener('click', (event) => {
      event.stopPropagation();
      const confirmMessage = "注：記事を消去しますか？";

      // 特定のボタン（例: .delete-buttonクラスを持つボタン）の場合の処理
      if (button.classList.contains('show-delete')) {
        if (!confirm(confirmMessage)) {
          event.preventDefault();
        }
      }
    });
  });
});