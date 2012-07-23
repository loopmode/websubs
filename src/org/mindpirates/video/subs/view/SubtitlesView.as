package org.mindpirates.video.subs.view
{
	import com.greensock.TweenLite;
	
	import embed.fonts.EmbeddedFonts;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.filters.DropShadowFilter;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.mindpirates.video.events.SubtitleEvent;
	import org.mindpirates.video.events.SubtitleFileLoaderEvent;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.Subtitles;
	import org.mindpirates.video.subs.VideoServices;
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	import org.mindpirates.video.vimeo.VimeoSubtitlesUI;
	
	/**
	 * The <code>SubtitlesView</code> class contains the textfield for displaying subtitles.It takes care of positioning and scaling.
	 */
	public class SubtitlesView extends Sprite
	{
		private var _subtitlesTextField:SubtitleTextField;
		private var _statusTextField:TextField;
		private var _ui:SubtitlesUI;
		private var _subs:Subtitles;
		private var statusWatcher:StatusWatcher;
		
		
		public function SubtitlesView(target:Subtitles)
		{
			super(); 
			
			visible = false;
			_subs = target;
			createTextField();
			createUI();
			
			subs.main.videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			subs.main.addEventListener(SubtitleEvent.FILE_LOAD, handleFileload);
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		protected function handleFileload(event:SubtitleEvent):void
		{
			event.file.addEventListener(SubtitleFileLoaderEvent.COMPLETE, handleFileLoaded);
			statusWatcher = new StatusWatcher(subs, event.file);
		}		
		
		protected function handleFileLoaded(event:Event):void
		{
			var file:SubtitleFileLoader = event.target as SubtitleFileLoader;
			file.addEventListener(SubtitleFileLoaderEvent.COMPLETE, handleFileLoaded);
			statusWatcher.destroy();
		}
		
		public function destroy():void
		{
			_ui.destroy();
			removeListeners(); 
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		/*
		--------------------------------------------------------------------------
		
		PUBLIC GETTERS
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * The target <code>Subtitles</code> instance.
		 * @see org.mindpirates.video.subs.Subtitles
		 */
		public function get subs():Subtitles
		{
			return _subs;
		}
		
		/**
		 * The UI that contains a comboBox for selecting the subtitle file and any additional UI elements.<br>
		 * It can vary depending on the videoService in use and contains its own logic for updating and does not need to be controlled from here.
		 * @see org.mindpirates.video.subs.view.SubtitlesUI
		 */
		public function get ui():SubtitlesUI
		{
			return _ui;
		}
		
		/**
		 * The textfield that is used to display the subtitles.
		 * @see org.mindpirates.video.subs.view.SubtitleTextField
		 */
		public function get subtitlesTextField():SubtitleTextField
		{
			return _subtitlesTextField;
		}
		
		/**
		 * The textfield that is used to display the status messages.
		 */
		public function get statusTextField():TextField
		{
			return _statusTextField;
		}
		
		
		/*
		--------------------------------------------------------------------------
		
		STATUS TEXT
		
		--------------------------------------------------------------------------
		*/
		
		
		
		public function set statusMessage(value:String):void
		{ 
			if (value) {
				if (!_statusTextField) {
					createStatusTextfield();
				} 
				_statusTextField.text = value;
				_statusTextField.alpha = 1;
			}
			else {
				TweenLite.to(_statusTextField, 1, {alpha:0});
			}
		}
	
		public function get statusMessage():String
		{ 
			if (_statusTextField) {
				return _statusTextField.text;
			}
			return null;
		}
		
		
		
		
		/*
		--------------------------------------------------------------------------
		
		CREATOR FUNCTIONS
		
		--------------------------------------------------------------------------
		*/
		
		public function createStatusTextfield():void
		{
			_statusTextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 8;
			format.font = EmbeddedFonts.UNI_05_53;
			format.color = 0xffffff; 
			format.align = TextFormatAlign.LEFT;
			_statusTextField.embedFonts = true;
			_statusTextField.selectable = false;
			_statusTextField.multiline = false;
			_statusTextField.filters = [new DropShadowFilter(4,45,0,0.5)];
			_statusTextField.defaultTextFormat = format;
			_statusTextField.autoSize = TextFieldAutoSize.LEFT;
			//_statusTextField.x = ui.comboBox.x + ui.comboBox.width + 5;
			//_statusTextField.y = stage.stageHeight - 5 - _statusTextField.height;
			_statusTextField.x = 2;
			_statusTextField.y = stage.stageHeight - _statusTextField.height - 2;
			addChild(_statusTextField); 
		}
		
		
		/** 
		 * creates the textfield
		 * @see #textField
		 */
		private function createTextField():void
		{
			_subtitlesTextField = new SubtitleTextField(_subs);
			addChild(_subtitlesTextField);
		}
		
		/**
		 * creates the UI
		 * @see #ui
		 */
		private function createUI():void
		{ 
			switch (_subs.main.videoServiceName) {
				case VideoServices.VIMEO:
					_ui = new VimeoSubtitlesUI(_subs);
			}
			addChild(_ui);
		}
		
		/*
		--------------------------------------------------------------------------
		
		EVENT LISTENERS
		
		--------------------------------------------------------------------------
		*/
		
		public function handleAdded(event:Event):void
		{
			addListeners();
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			layout();
		}
		
		public function handleRemoved(event:Event):void
		{
			removeListeners();
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		
		public function addListeners():void
		{
			subs.main.addEventListener(SubtitleEvent.LINE_CHANGED, handleSubtitleLineChanged);
			stage.addEventListener(Event.RESIZE, handleStageResize); 
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreenChange);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
			
		
		public function removeListeners():void
		{
			subs.main.removeEventListener(SubtitleEvent.LINE_CHANGED, handleSubtitleLineChanged);
			stage.removeEventListener(Event.RESIZE, handleStageResize); 
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
		
		/*
		--------------------------------------------------------------------------
		
		EVENT HANDLERS
		
		--------------------------------------------------------------------------
		*/
		
		protected function handleSubtitleLineChanged(event:Event):void
		{
			layout();
		}	
		
		public function handlePlayerReady(event:Event):void
		{
			subs.main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady); 
			visible = true;
			layout();
		}	
		 
		public function handleStageResize(event:Event):void
		{		
			layout();
		}
		
		public function handleFullscreenChange(event:FullScreenEvent):void
		{
			layout();
		}
		
		public function layout():void
		{
			var tf:TextField = subtitlesTextField;
			var tfStat:TextField = _statusTextField;
			
			if (tf) {
				tf.scaleX = tf.scaleY = subs.main.currentScale;
				tf.width =  stage.stageWidth - 20; 
				/*
				if (stage.displayState === StageDisplayState.NORMAL) {
					tf.width =  stage.stageWidth - 20; 
				}
				else {
					var videos:Array = subs.main.videoPlayer.findPlayerChildren(Video);					
					if (videos.length) {
						var video:Video = videos[0];
						tf.width = video.width;
					}
				}
				*/
				
				//var fontSize:Number = subs.main.currentScale * (subs.currentFile && subs.currentFile.fontSize ? subs.currentFile.fontSize : subs.main.flashVars.defaultFontSize);
				tf.x = 0.5 * (stage.stageWidth - subtitlesTextField.width);
				tf.y =  stage.stageHeight - tf.height - subs.main.flashVars.textfieldMarginBottom;
			}
			if (tfStat) {
				tfStat.x = 2;
				tfStat.y = stage.stageHeight - tfStat.height - 2;
			}
		}
		
		
		
	}
}