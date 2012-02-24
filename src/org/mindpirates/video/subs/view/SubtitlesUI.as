package org.mindpirates.video.subs.view
{
	import com.greensock.TweenLite;
	
	import embed.fonts.EmbeddedFonts;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import net.stevensacks.preloaders.CircleSlicePreloader;
	
	import org.mindpirates.video.VideoPlayerBase;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.Subtitles;
	
	public class SubtitlesUI extends Sprite
	{
		/**
		 * The ComboBox for selecting the subtitles file
		 */
		public var comboBox:SubsComboBox;
		
		/**
		 * holds the value for <code>subtitles</code>
		 * @see #subtitles
		 */
		private var _subs:Subtitles;
		
		//private var _videoPlayer:VideoPlayerBase;
		 
		public var statusTextfield:TextField;
		  
		
		public function SubtitlesUI(target:Subtitles)
		{
			super();

			visible = false;
			
			_subs = target;
			
			//_videoPlayer = subs.main.videoPlayer;
			subs.main.videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			
			
			comboBox = new SubsComboBox();  
			comboBox.height = comboBox.dropdown.rowHeight = 17; 
			addChild(comboBox);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
			
		}
		 
		 
		/**
		 * Destroys the instance and removes all event listeners.
		 */
		public function destroy():void
		{ 
			removeListeners();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		/**
		 * The <code>Subtitles</code> instance
		 * @see org.mindpirates.video.subs.Subtitles
		 */
		public function get subs():Subtitles
		{
			return _subs;
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
		}
		
		public function handleRemoved(event:Event):void
		{
			removeListeners();
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		
		public function addListeners():void
		{
			stage.addEventListener(Event.RESIZE, handleStageResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreenChanged);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
				
		
		public function removeListeners():void
		{
			stage.removeEventListener(Event.RESIZE, handleStageResize);
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreenChanged);
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
		
		/*
		--------------------------------------------------------------------------
		
		EVENT HANDLERS
		
		--------------------------------------------------------------------------
		*/
		
		public function handlePlayerReady(event:Event):void
		{
			subs.main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			visible = true;
			layout();
		}	
		
		public function handleEnterFrame(event:Event):void
		{
			 
		}
		
		public function handleFullscreenChanged(event:FullScreenEvent):void
		{
			layout();
		}		
		
		public function handleStageResize(event:Event):void
		{		
			layout();
		}
		
		public function set statusMessage(value:String):void
		{ 
			if (value) {
				if (!statusTextfield) {
					createStatusTextfield();
				} 
				statusTextfield.text = value;
				statusTextfield.alpha = 0.3;
			}
			else {
				TweenLite.to(statusTextfield, 1, {alpha:0});
			}
		}
		
		public function createStatusTextfield():void
		{
			statusTextfield = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 8;
			format.font = EmbeddedFonts.UNI_05_53;
			format.color = 0xFFFFFF; 
			statusTextfield.embedFonts = true;
			statusTextfield.selectable = false;
			statusTextfield.multiline = false;
			statusTextfield.filters = [new DropShadowFilter()];
			statusTextfield.defaultTextFormat = format;
			statusTextfield.autoSize = TextFieldAutoSize.LEFT;
			statusTextfield.x = 5;
			addChild(statusTextfield); 
		}
		public function get statusMessage():String
		{ 
			if (statusTextfield) {
				return statusTextfield.text;
			}
			return null;
		}
		/*
		--------------------------------------------------------------------------
		
		LAYOUT
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Applies layout to the subtitlesUI. Must be implemented by derived classes to work well with the external videoplayer's UI.
		 */
		public function layout():void
		{ 
		}
		
		
	}
}