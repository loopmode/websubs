package org.mindpirates.video.subs.view
{
	import de.loopmode.tooltips.Tooltip;
	import de.loopmode.tooltips.Tooltips;
	import de.loopmode.tooltips.backgrounds.TooltipArrowBackground;
	
	import embed.fonts.EmbeddedFonts;
	
	import fl.controls.Button;
	import fl.events.ComponentEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.Subtitles;
	
	public class SubtitlesUI extends Sprite
	{
		/**
		 * The ComboBox for selecting the subtitles file
		 */
		public var comboBox:SubsComboBox;
		
		public var btnIncreaseSize:SubsButton;
		public var btnDecreaseSize:SubsButton;
		
		/**
		 * holds the value for <code>subtitles</code>
		 * @see #subtitles
		 */
		private var _subs:Subtitles;
		
		//private var _videoPlayer:VideoPlayerBase;
		 
		  
		
		public function SubtitlesUI(target:Subtitles)
		{
			super();

			visible = false;
			
			_subs = target;
			
			subs.main.videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			
			createComboBox();
			createButtons();
			
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
			
		}
		
		private function createButtons():void
		{
			btnIncreaseSize = new SubsButton();
			btnIncreaseSize.label = '';
			btnIncreaseSize.tf.text = '+';	
			btnIncreaseSize.tooltip = 'Increase size of subtitles';
			btnIncreaseSize.addEventListener(MouseEvent.CLICK, subs.increaseTextSize);
			addChild(btnIncreaseSize);
			
			btnDecreaseSize = new SubsButton();
			btnDecreaseSize.label = '';
			btnDecreaseSize.tf.text = '-';	
			btnDecreaseSize.tooltip = 'Decrease size of subtitles'; 
			btnDecreaseSize.addEventListener(MouseEvent.CLICK, subs.decreaseTextSize);
			addChild(btnDecreaseSize);
		}
		 
		
		protected function createComboBox():void
		{
			comboBox = new SubsComboBox();  
			comboBox.height = comboBox.dropdown.rowHeight = 17; 
			comboBox.addEventListener(Event.CHANGE, layout);
			addChild(comboBox);
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
		
		/*
		--------------------------------------------------------------------------
		
		LAYOUT
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Applies layout to the subtitlesUI. Must be implemented by derived classes to work well with the external videoplayer's UI.
		 */
		public function layout(event:Event=null):void
		{ 
		}
		
		
	}
}