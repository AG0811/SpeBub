console.log('image_preview.jsを読み込みました')
document.addEventListener('turbo:load', () => {
  // 画像ファイルが選択された時の処理
  document.querySelector('#news_images').addEventListener('change', function() {
    const preview = document.querySelector('#image-preview');
    preview.innerHTML = ''; // プレビューをクリアする

    const files = Array.from(this.files);

    files.forEach(file => {
      if (!file.type.startsWith('image/')) { // 画像ファイルでなければスキップ
        return;
      }

      const reader = new FileReader();
      reader.onload = function(e) {
        const img = document.createElement('img');
        img.src = e.target.result;
        img.style.maxWidth = '200px'; // プレビューの最大幅を設定
        img.style.marginRight = '10px'; // 余白を追加
        preview.appendChild(img);
      };

      reader.readAsDataURL(file);
    });
  });
});