/**
 * @license Copyright (c) 2003-2022, CKSource Holding sp. z o.o. All rights reserved.
 * For licensing, see LICENSE.md or https://ckeditor.com/legal/ckeditor-oss-license
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'ja', {
	title: 'ユーザー補助の説明',
	contents: 'ヘルプ　このダイアログを閉じるには ESCを押してください。',
	legend: [
		{
		name: '全般',
		items: [
			{
			name: 'エディターツールバー',
			legend: '${toolbarFocus} を押すとツールバーのオン/オフ操作ができます。カーソルをツールバーのグループで移動させるにはTabかSHIFT+Tabを押します。グループ内でカーソルを移動させるには、右カーソルか左カーソルを押します。スペースキーやエンターを押すとボタンを有効/無効にすることができます。'
		},

			{
			name: '編集ダイアログ',
			legend:
				'Inside a dialog, press TAB to navigate to the next dialog element, press SHIFT+TAB to move to the previous dialog element, press ENTER to submit the dialog, press ESC to cancel the dialog. When a dialog has multiple tabs, the tab list can be reached either with ALT+F10 or with TAB as part of the dialog tabbing order. With tab list focused, move to the next and previous tab with RIGHT and LEFT ARROW, respectively.'  // MISSING
		},

			{
			name: 'エディターのメニュー',
			legend: '${contextMenu} キーかAPPLICATION KEYを押すとコンテキストメニューが開きます。Tabか下カーソルでメニューのオプション選択が下に移動します。戻るには、SHIFT+Tabか上カーソルです。スペースもしくはENTERキーでメニューオプションを決定できます。現在選んでいるオプションのサブメニューを開くには、スペース、もしくは右カーソルを押します。サブメニューから親メニューに戻るには、ESCか左カーソルを押してください。ESCでコンテキストメニュー自体をキャンセルできます。'
		},

			{
			name: 'エディターリストボックス',
			legend: 'リストボックス内で移動するには、Tabか下カーソルで次のアイテムへ移動します。SHIFT+Tabで前のアイテムに戻ります。リストのオプションを選択するには、スペースもしくは、ENTERを押してください。リストボックスを閉じるには、ESCを押してください。'
		},

			{
			name: 'エディター要素パスバー',
			legend: '${elementsPathFocus} を押すとエレメントパスバーを操作出来ます。Tabか右カーソルで次のエレメントを選択できます。前のエレメントを選択するには、SHIFT+Tabか左カーソルです。スペースもしくは、ENTERでエディタ内の対象エレメントを選択出来ます。'
		}
		]
	},
		{
		name: 'コマンド',
		items: [
			{
			name: '元に戻す',
			legend: '${undo} をクリック'
		},
			{
			name: 'やり直し',
			legend: '${redo} をクリック'
		},
			{
			name: '太字',
			legend: '${bold} をクリック'
		},
			{
			name: '斜体 ',
			legend: '${italic} をクリック'
		},
			{
			name: '下線',
			legend: '${underline} をクリック'
		},
			{
			name: 'リンク',
			legend: '${link} をクリック'
		},
			{
			name: 'ツールバーをたたむ',
			legend: '${toolbarCollapse} をクリック'
		},
			{
			name: '前のカーソル移動のできないポイントへ',
			legend: '${accessPreviousSpace} を押すとカーソルより前にあるカーソルキーで入り込めないスペースへ移動できます。例えば、HRエレメントが2つ接している場合などです。離れた場所へは、複数回キーを押します。'
		},
			{
			name: '次のカーソルポイントへ移動する',
			legend: '${accessNextSpace} を押すとカーソルより後ろにあるカーソルキーで入り込めないスペースへ移動できます。例えば、HRエレメントが2つ接している場合などです。離れた場所へは、複数回キーを押します。'
		},
			{
			name: 'ユーザー補助ヘルプ',
			legend: '${a11yHelp} をクリック'
		},
			{
			name: ' Paste as plain text', // MISSING
			legend: 'Press ${pastetext}', // MISSING
			legendEdge: 'Press ${pastetext}, followed by ${paste}' // MISSING
		}
		]
	}
	],
	tab: 'Tab',
	pause: 'Pause',
	capslock: 'Caps Lock',
	escape: 'Escape',
	pageUp: 'Page Up',
	pageDown: 'Page Down',
	leftArrow: '左矢印',
	upArrow: '上矢印',
	rightArrow: '右矢印',
	downArrow: '下矢印',
	insert: 'Insert',
	leftWindowKey: '左Windowキー',
	rightWindowKey: '右のWindowキー',
	selectKey: 'Select',
	numpad0: 'Num 0',
	numpad1: 'Num 1',
	numpad2: 'Num 2',
	numpad3: 'Num 3',
	numpad4: 'Num 4',
	numpad5: 'Num 5',
	numpad6: 'Num 6',
	numpad7: 'Num 7',
	numpad8: 'Num 8',
	numpad9: 'Num 9',
	multiply: '掛ける',
	add: '足す',
	subtract: '引く',
	decimalPoint: '小数点',
	divide: '割る',
	f1: 'F1',
	f2: 'F2',
	f3: 'F3',
	f4: 'F4',
	f5: 'F5',
	f6: 'F6',
	f7: 'F7',
	f8: 'F8',
	f9: 'F9',
	f10: 'F10',
	f11: 'F11',
	f12: 'F12',
	numLock: 'Num Lock',
	scrollLock: 'Scroll Lock',
	semiColon: 'セミコロン',
	equalSign: 'イコール記号',
	comma: 'カンマ',
	dash: 'ダッシュ',
	period: 'ピリオド',
	forwardSlash: 'フォワードスラッシュ',
	graveAccent: 'グレイヴアクセント',
	openBracket: '開きカッコ',
	backSlash: 'バックスラッシュ',
	closeBracket: '閉じカッコ',
	singleQuote: 'シングルクォート'
} );