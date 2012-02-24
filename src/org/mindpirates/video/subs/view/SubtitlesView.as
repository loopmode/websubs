package org.mindpirates.video.subs.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.media.Video;
	
	import org.mindpirates.video.events.SubtitleEvent;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.Subtitles;
	import org.mindpirates.video.subs.VideoServices;
	import org.mindpirates.video.vimeo.VimeoSubtitlesUI;
	
	/**
	 * The <code>SubtitlesView</code> class contains the textfield for displaying subtitles.It takes care of positioning and scaling.
	 */
	public class SubtitlesView extends Sprite
	{
		private var _textfield:SubtitleTextField;
		private var _ui:SubtitlesUI;
		private var _subs:Subtitles;
		
		public function SubtitlesView(target:Subtitles)
		{
			super(); 
			
			visible = false;
			_subs = target;
			createTextField();
			createUI();
			
			subs.main.videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
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
		public function get textField():SubtitleTextField
		{
			return _textfield;
		}
		
		
		/*
		--------------------------------------------------------------------------
		
		CREATOR FUNCTIONS
		
		--------------------------------------------------------------------------
		*/
		
		/** 
		 * creates the textfield
		 * @see #textField
		 */
		private function createTextField():void
		{
			_textfield = new SubtitleTextField(_subs);
			addChild(_textfield);
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
		
		public function layout():void
		{
			textField.scaleX = textField.scaleY = subs.main.currentScale;
			textField.width = stage.stageWidth - 20; 
			
			//var fontSize:Number = subs.main.currentScale * (subs.currentFile && subs.currentFile.fontSize ? subs.currentFile.fontSize : subs.main.flashVars.defaultFontSize);
			textField.x = 0.5 * (stage.stageWidth - textField.width);
			textField.y =  stage.stageHeight - textField.height - subs.main.flashVars.textfieldMarginBottom;
		}
		
	}
}