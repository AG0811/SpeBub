console.log('news_filter.jsを読み込みました');
document.addEventListener('turbo:load', () => {
  const userDataDiv = document.getElementById('user-data');

  if (!userDataDiv) {
    console.error('#user-data element not found');
    return;
  }

  const userId = userDataDiv.dataset.userId; // ユーザーIDを取得
  const menuItems = document.querySelectorAll('.menu .item'); // メニュー項目を取得
  const selectElement = document.getElementById('prefecture-select'); // 都道府県選択要素を取得
  const defaultItem = document.querySelector('.menu .item[data-filter="all"]'); // デフォルトのメニュー項目を取得
  const newsItems = document.querySelectorAll('.news-item'); // ニュース項目を取得
  const dateSeparators = document.querySelectorAll('.news-date-separator'); // 日付の区切り要素を取得
  let userAddressId = selectElement.value; // 初期の都道府県の値を取得
  let isSearchActive = false; // 検索フィルタが有効かどうかのフラグ

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
    clickedItem.style.backgroundColor = '#ff9800'; // クリックされたアイテムの背景色を変更

    if (clickedItem.dataset.filter === 'search') {
      selectElement.classList.remove('hidden'); // 検索フィルタが選択された場合はセレクト要素を表示
      const selectedPrefectureId = selectElement.value;
      filterNewsItems('search', selectedPrefectureId);
      isSearchActive = true;
    } else {
      selectElement.classList.add('hidden'); // それ以外のフィルタが選択された場合はセレクト要素を非表示
      filterNewsItems(clickedItem.dataset.filter);
      isSearchActive = false;
    }
  };

  // ニュースアイテムをフィルタリングする関数
  const filterNewsItems = (filter, selectedPrefectureId = null) => {
    const displayedDates = new Set();

    newsItems.forEach(item => {
      const userItemId = item.dataset.userId; // ニュースアイテムのユーザーIDを取得
      const prefectureId = item.dataset.prefectureId;
      const newsDate = item.dataset.date;
      const isFavoritedByCurrentUser = item.dataset.favoritedByCurrentUser === 'true'; // ニュースがユーザーによってお気に入りされているかを取得

      let shouldDisplay = false;
      if (filter === 'all') {
        shouldDisplay = prefectureId === userAddressId; // ユーザーの都道府県と一致するニュースアイテムのみ表示
      } else if (filter === 'favorite') {
        shouldDisplay = isFavoritedByCurrentUser; // お気に入りされたニュースアイテムのみ表示
      } else if (filter === 'unread') {
        // 未読のフィルタリングロジックを実装する（必要に応じて）
      } else if (filter === 'search') {
        shouldDisplay = prefectureId === selectedPrefectureId; // 選択された都道府県と一致するニュースアイテムのみ表示
      } else if (filter === 'mine') {
        shouldDisplay = userItemId === userId; // ユーザーが投稿したニュースアイテムのみ表示
      }

      item.style.display = shouldDisplay ? 'block' : 'none'; // 表示・非表示を設定
      if (shouldDisplay) {
        displayedDates.add(newsDate); // 表示される日付をセットに追加
      }
    });

    // 日付区切り要素の表示・非表示を設定
    dateSeparators.forEach(separator => {
      const separatorDate = separator.dataset.date;
      separator.style.display = displayedDates.has(separatorDate) ? 'block' : 'none';
    });
  };

  // 各メニューアイテムにクリックイベントを設定
  menuItems.forEach(item => {
    item.addEventListener('click', handleMenuItemClick);
  });

  // デフォルトのメニューアイテムを設定
  if (defaultItem) {
    defaultItem.style.backgroundColor = '#ff9800';
    filterNewsItems(defaultItem.dataset.filter);
  }

  selectElement.classList.add('hidden'); // 初期状態でセレクト要素を非表示に設定
  selectElement.addEventListener('change', (event) => {
    const selectedPrefectureId = event.target.value;
    filterNewsItems('search', selectedPrefectureId);
    isSearchActive = true;
  });
});
