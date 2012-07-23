package org.mindpirates.video.vimeo
{
	import embed.fonts.EmbeddedFonts;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import mx.utils.StringUtil;
	
	import org.mindpirates.video.VideoPlayerBase;
	import org.mindpirates.video.events.SubtitleEvent;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.SubtitleLine;
	import org.mindpirates.video.subs.Subtitles;
	import org.mindpirates.video.subs.view.SubtitlesUI;
	
	import utils.StringUtils;

	public class VimeoSubtitlesUI extends SubtitlesUI
	{
		
		/**
		 * Amount of miliseconds for the delay of the <code>layout()</code> call when fullscreen state changes.
		 * @see #handleFullscreenChanged()
		 */
		private const FULLSCREEN_LAYOUT_DELAY:Number = 150;
		
		/**
		 * Cached values for the selectBox position.<br>
		 * Needed to apply positioning correctly when leaving fullscreen state, and the moogaloop UI is not available.
		 */
		private var _initialSelectBoxPosition:Point;
		
		
		private var tf1:TextField;
		private var tf2:TextField;
		private var tf3:TextField;
		
		public function VimeoSubtitlesUI(target:Subtitles)
		{
			super(target); 
			moogaloop.addEventListener(VideoPlayerEvent.PLAY_PROGRESS, handlePlaybackStartedOnce);
			comboBox.addEventListener(Event.RESIZE, layout);
			
			target.main.addEventListener(SubtitleEvent.LINE_CHANGED, layout);
			/*
			tf1 = tmp_createTF();
			tf2 = tmp_createTF();
			tf2.y = 25;
			tf3 = tmp_createTF();
			tf3.y = 75;
			*/
		}
		
		private function tmp_createTF():TextField
		{
			var tf:TextField = new TextField();
			tf.background = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.height = 20;
			tf.textColor = 0x000000;
			subs.main.stage.addChild(tf);
			return tf;
			
		}		
		
		
		
		/*
		--------------------------------------------------------------------------
		
		LAYOUT
		
		--------------------------------------------------------------------------
		*/
		
		
		/**
		 * Checks the opacity of the moogaloop UI and applies it to itself.<br>
		 * When there was no user input for a while, moogaloop fades out its UI, and our subtitles UI must respond to that.
		 * TODO: Find a good way to apply alpha on the items of the <code>selectBox</code> ComboBox in the subtitles UI without ugly side effects.
		 */
		override public function handleEnterFrame(event:Event):void
		{
			var a:Number = 0;
			if (moogaloop.ui.controlBar && moogaloop.ui.controlBar.alpha) {
				a = moogaloop.ui.controlBar.alpha;
			}
			alpha = a; 
			layout();
			/*
			if (subs && subs.main && subs.main.videoPlayer) {
				tf1.text = StringUtils.videoTime(subs.main.videoPlayer.positionTime);
				
				var nss:Array = findChild(subs.main.videoPlayer.player as DisplayObjectContainer, 'NetStream');
				var ns:NetStream = nss[0];
				if (ns) {
					tf1.text += "\n" + StringUtils.videoTime(  ns.time  );
				}
				var line:SubtitleLine = subs.currentLine;
				if (line) {
					tf2.text = StringUtils.videoTime(line.start * 1000) + ' --> ' + StringUtils.videoTime(line.end * 1000);
					tf3.text = line.text;
				}
				else {
					tf2.text = '-';
					tf3.text = '-';
				}
			}
			*/
			//subs.view.ui.selectBox.dropdown.alpha = a;
		}
		
		/**
		 * Applies a delayed <code>layout()</code> call based on the <code>FULLSCREEN_LAYOUT_DELAY</code> value.<br>
		 * Moogaloop seems to have a delayed layout function itself, and the UI positions are not correct directly after the fullscreen event.
		 * As a workaround, we set a delayed call to our layout function.
		 * @see #FULLSCREEN_LAYOUT_DELAY
		 */
		override public function handleFullscreenChanged(event:FullScreenEvent):void
		{
			visible = false;
			var t:Timer = new Timer(FULLSCREEN_LAYOUT_DELAY, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				visible = true;
				layout();
			}, false, 0, true);
			t.start();	
		}
		
		
		/**
		 * Adds the subtitles textfield above the video but below the player controls, so that the textfield does not block mouse interactions with the controls.
		 * Executes once as soon as the VideoController class is instantioated within moogaloop. 
		 */
		protected function handlePlaybackStartedOnce(event:Event):void
		{  
			var videoController:Sprite = findChild(moogaloop, 'VideoController')[0]; 
			if (videoController) {
				moogaloop.removeEventListener(VideoPlayerEvent.PLAY_PROGRESS, handlePlaybackStartedOnce);
				videoController.addChild(subs.view.subtitlesTextField);
			}
		}	
		
		
		override public function layout(event:Event=null):void
		{
			super.layout();
			
			// set the comboWrapper position right above moogaloop's play button
			try {
				comboBox.x = moogaloop.ui.controlBar.x + moogaloop.ui.playPauseButton.x;
				comboBox.y = moogaloop.ui.playPauseButton.y - comboBox.height - 5;
			}
			catch (err:Error) {
				// when leaving fullscreen mode, an error is thrown when trying to access moogaloop's UI elements.
				// therefore, we use cached values of the position
				if (_initialSelectBoxPosition) {
					comboBox.x = _initialSelectBoxPosition.x;
					comboBox.y = _initialSelectBoxPosition.y;
				}
			}
			
			var tf:TextField;
			
			btnIncreaseSize.width = comboBox.height;
			btnIncreaseSize.height = comboBox.height;
			btnIncreaseSize.y = comboBox.y;
			btnIncreaseSize.x = comboBox.x + comboBox.width + 5;
			tf = btnIncreaseSize.getChildByName('tf') as TextField;
			tf.x = 0.5 * (btnIncreaseSize.width - tf.width) + 1;
			tf.y = 0.5 * (btnIncreaseSize.height - tf.height) - 1;
			
			btnDecreaseSize.width = comboBox.height;
			btnDecreaseSize.height = comboBox.height;
			btnDecreaseSize.y = comboBox.y;
			btnDecreaseSize.x = btnIncreaseSize.x + btnIncreaseSize.width + 5;
			tf = btnDecreaseSize.getChildByName('tf') as TextField;
			tf.x = 0.5 * (btnDecreaseSize.width - tf.width) + 1;
			tf.y = 0.5 * (btnDecreaseSize.height - tf.height) - 1;
			
			if (!_initialSelectBoxPosition) {
				_initialSelectBoxPosition = new Point(comboBox.x, comboBox.y);
			}
		}
		
		 
		/*
		--------------------------------------------------------------------------
		
		VIDEOPLAYER
		
		--------------------------------------------------------------------------
		*/
		 
		/**
		 * A Reference to the videoplayer casted as <code>VimeoPlayer</code>
		 * @see org.mindpirates.video.vimeo.VimeoPlayer
		 */
		public function get moogaloop():VimeoPlayer
		{
			return subs.main.videoPlayer as VimeoPlayer
		}
		 
	}
}