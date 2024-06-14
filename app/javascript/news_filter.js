document.addEventListener('turbo:load', () => {
  const menuItems = document.querySelectorAll('.menu .item');
  const selectElement = document.getElementById('prefecture-select');
  const defaultItem = document.querySelector('.menu .item[data-filter="all"]');
  const newsItems = document.querySelectorAll('.news-item');
  const userAddressId = selectElement.querySelector('option[selected]').value;

  // すべてのメニューアイテムから背景色を削除する関数
  const resetBackgroundColors = () => {
    menuItems.forEach(item => {
      item.style.backgroundColor = '';
    });
  };

  // メニューアイテムクリックを処理する関数
  const handleMenuItemClick = (event) => {
    resetBackgroundColors();
    const clickedItem = event.target;
    clickedItem.style.backgroundColor = '#ccc'; // 例：必要に応じて変更

    if (clickedItem.dataset.filter === 'search') {
      selectElement.classList.remove('hidden');
      const selectedPrefectureId = selectElement.value;
      filterNewsItems('search', selectedPrefectureId);
    } else {
      selectElement.classList.add('hidden');
      filterNewsItems(clickedItem.dataset.filter);
    }

    // // ページのURLを 'http://localhost:3000/' に変更
    // setTimeout(() => {
    //   window.location.href = '/';
    // }, 100); // 100ミリ秒後にページをリロード
  };

  // ニュースアイテムをフィルタリングする関数
  const filterNewsItems = (filter, selectedPrefectureId = null) => {
    newsItems.forEach(item => {
      const prefectureId = item.dataset.prefectureId;
      const categoryId = item.dataset.categoryId;
      if (filter === 'all') {
        item.style.display = prefectureId === userAddressId ? 'block' : 'none';
      } else if (filter === 'favorite') {
        // お気に入りのフィルタリングロジックを実装する（必要に応じて）
        item.style.display = 'none'; // 例：今はすべてのアイテムを非表示にする
      } else if (filter === 'unread') {
        // 未読のフィルタリングロジックを実装する（必要に応じて）
        item.style.display = 'none'; // 例：今はすべてのアイテムを非表示にする
      } else if (filter === 'search') {
        if (prefectureId === selectedPrefectureId) {
          item.style.display = 'block';
        } else {
          item.style.display = 'none';
        }
      }
    });
  };

  // すべてのメニューアイテムにクリックイベントリスナーを追加する
  menuItems.forEach(item => {
    item.addEventListener('click', handleMenuItemClick);
  });

  // デフォルトの選択されたアイテムを設定する
  if (defaultItem) {
    defaultItem.style.backgroundColor = '#ccc'; // 例：必要に応じて変更
    filterNewsItems(defaultItem.dataset.filter); // 初期フィルタリング
  }

  // 最初はセレクト要素を非表示にする
  selectElement.classList.add('hidden');

  // セレクト要素に変更イベントリスナーを追加する
  selectElement.addEventListener('change', (event) => {
    const selectedPrefectureId = event.target.value;
    filterNewsItems('search', selectedPrefectureId);
  });
});
