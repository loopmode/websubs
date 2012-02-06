package org.mindpirates.video.subs
{
	import embed.Fonts;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.utils.Timer;
	
	import org.mindpirates.video.VideoPlayerBase;
	import org.mindpirates.video.events.SubtitleListEvent;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	import org.mindpirates.video.subs.loading.SubtitlesListLoader;
	import org.mindpirates.video.subs.view.SubtitlesUI;
	import org.mindpirates.video.subs.view.SubtitlesView;
	import org.mindpirates.video.vimeo.VimeoSubtitlesUI;
	
	/**
	 * This class displays subtitles for a videoPlayer.<br> 
	 * It creates the view containing a textfield and UI elements and a timer-based controller.
	 */
	public class Subtitles
	{
		  
		/**
		 * The SubtitlesList that loads the XML file containing paths to individual subtitle files.
		 */
		private var listLoader:SubtitlesListLoader;

		/**
		 * A Sprite that holds required UI elements.
		 */
		private var ui:SubtitlesUI;
		 
		
		/**
		 * Embeds the required fonts.
		 * @see org.mindpirates.video.subs.Fonts
		 */
		public static var fonts:Fonts = new Fonts();
		
		/*
		-------------------------------------------------------------------------------------
		
		CONSTRUCT / DESTROY
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * The timer for updating the subtitles
		 */
		private var timer:Timer;
		
		/**
		 * Amount of miliseconds for the update timer interval.
		 */
		public static const TIMER_INTERVAL:int = 40;
		
		/**
		 * Holds the value for <code>main</code>
		 * @see #main main
		 */
		private var _main:SubtitleVideoPlayer;
		
		/**
		 * The subtitle file that is currently used.
		 */
		private var _currentFile:SubtitleFileLoader;
		
		/**
		 * The <code>SubtitlesView</code> instance that contains the textfield.
		 * @see org.mindpirates.video.subs.view.SubtitlesView
		 */
		private var view:SubtitlesView;
		
		
		/**
		 * @param vars The flashvars passed from the HTML page
		 */
		public function Subtitles(target:SubtitleVideoPlayer)
		{
			super();  
			Fonts
			_main = target; 
			addPlayerEvents();
			createTimer();		
			createView();
			
			if (main.flashVars.subtitlesList) {
				loadSubtitlesList(main.flashVars.subtitlesList);
			}
			else {
				throw new Error('No subtitle list specified in flashvars!')
			}
		}
		
		/**
		 * Reference to the main application class.
		 * @see org.mindpirates.video.subs.SubtitleVideoPlayer
		 */
		public function get main():SubtitleVideoPlayer
		{
			return _main;
		}
		
		/**
		 * Destroys the instance and cleans up. Removes event listeners.
		 */
		public function destroy():void
		{
			destroyTimer();
			removePlayerEvents();
			ui.destroy();
		}
		
		/*
		-------------------------------------------------------------------------------------
		
		VIEW
		
		-------------------------------------------------------------------------------------
		*/
		 
		
		private function createView():void
		{

			view = new SubtitlesView(this);
			main.addChild(view);
			 
			// create the UI
			switch (main.videoServiceName) {
				case VideoServices.VIMEO:
					ui = new VimeoSubtitlesUI(this);
			}
			main.addChild(ui);
			
			// init UI elements
			if (main.flashVars.subtitlesList) {
				ui.selectBox.addEventListener(Event.CHANGE, handleSelectFileChange);			
			}
			else{
				ui.selectBox.visible = false;
			}
			 
			
			
		}
		
		/*
		-------------------------------------------------------------------------------------
		
		SUBTITLE LISTING
		
		-------------------------------------------------------------------------------------
		*/ 
		
		public function loadSubtitlesList(file:String):void
		{
			if (!file) {
				return;
			}
			listLoader = new SubtitlesListLoader();
			listLoader.addEventListener(SubtitleListEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			listLoader.load(new URLRequest(file+'?time='+new Date().time));
		}
		
		protected function handleSubtitlesListComplete(event:Event):void
		{
			listLoader.removeEventListener(SubtitleListEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			ui.selectBox.dataProvider = ui.selectBox.createDataProvider(listLoader.files);
			loadDefaultSubtitles();
		}		
		
		protected function handleSelectFileChange(event:Event):void
		{
			var fileLoader:SubtitleFileLoader = ui.selectBox.selectedItem.fileLoader;
			if (!fileLoader.isLoaded) {
				loadSubtitles( fileLoader );
			}
			else {
				displaySubtitles(fileLoader);
			}
		}
		
		/*
		-------------------------------------------------------------------------------------
		
		LOAD SUBTITLE FILE
		
		-------------------------------------------------------------------------------------
		*/ 
		
		/**
		 * Loads a subtitle file. Once the file is loaded, it will be displayed and set as <code>currentFile</code>.
		 * @param fileLoader A <code>SubtitleFileLoader</code> object.
		 */
		public function loadSubtitles(fileLoader:SubtitleFileLoader):void
		{
			fileLoader.addEventListener(Event.COMPLETE, handleSubtitleFileLoaded);
			fileLoader.load();
		}
		
		
		/**
		 * Attempts to load the default subtitle file. This can be overridden via flashvars:
		 * <ul>
		 * <li>1. if a 'subtitles' property was specified in the flashvars, and the value corresponds to either the ID or URL of an item in the XML list, that file will be used.</li>
		 * <li>2. if no file was determined based on the flashvars, the file specified by the "default_id" attribute of the root node in the XML list will be used.</li>
		 * <li>3. if both previous attempts fail, and the XML list contains at least one item, the file specified by the first XML item will be used.</li>
		 * </ul>
		 * If no file could be determined, a message is displayed via trace(). Otherwise the determined file will be loaded.
		 */
		private function loadDefaultSubtitles():void
		{
			var file:SubtitleFileLoader;
			if (main.flashVars.subtitles) {
				file = listLoader.getFileByID( main.flashVars.subtitles );
				if (!file) {
					file = listLoader.getFileByUrl( main.flashVars.subtitles );
				}
			} 
			else {
				if (!file) file = listLoader.defaultFile; 
				if (!file && listLoader.files && listLoader.files.length) file = listLoader.files[0];
			}
			if (file) {
				loadSubtitles( file );
			}
			else {
				trace(this, 'No subtitle file found to load.\nIf "subtitles" was specified via flashvars, check whether the value exactly matches the ID or URL of an item in the XML list.\nOtherwise check whether the "default_id" value of the root node in the XML list exactlymatches the ID of an item in the XML'); 
			}
		}
		
		/**
		 * Handles loading success of a subtitle file and diplays it.
		 */
		protected function handleSubtitleFileLoaded(event:Event):void
		{
			var file:SubtitleFileLoader = event.target as SubtitleFileLoader;
			file.removeEventListener(Event.COMPLETE, handleSubtitleFileLoaded);
			displaySubtitles(file);
		}
		
		/**
		 * Displays the subtitles of a loaded <code>SubtitleFileLoader</code>.
		 * @param file A <code>SubtitleFileLoader</code> that contains the subtitles.
		 */
		private function displaySubtitles(file:SubtitleFileLoader):void
		{ 
			_currentFile = file;
			if (main.videoPlayer.isReady && !timer.running) {
				timer.start();
			}
			var listIndex:int = ui.selectBox.getFileIndex( file );
			if (listIndex > -1) {
				ui.selectBox.selectedIndex = listIndex;
			}
		}
		 
		
		/*
		-------------------------------------------------------------------------------------
		
		TIMER
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * Creates the <code>timer</code> and registers the <code>TimerEvent.TIMER</code> event listener.
		 * @see #timer
		 */
		private function createTimer():void
		{
			if (timer) {
				destroyTimer();
			}
			timer = new Timer( TIMER_INTERVAL );
			timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		/**
		 * Destroys the <code>timer</code> and removes the <code>TimerEvent.TIMER</code> event listener.
		 */
		private function destroyTimer():void
		{
			if (!timer) {
				return;
			}
			timer.removeEventListener(TimerEvent.TIMER, handleTimer);
			timer = null;
		}
		
		
		protected function handleTimer(event:TimerEvent):void
		{
			if (!_currentFile) {
				return;
			}
			var file:SubtitleFileLoader = _currentFile;
			var line:SubtitleLine = file.subtitles.getLineAtTime( main.videoPlayer.positionTime ); 
			 
			if (line) {
				view.textfield.text = line.text;
			}
			else {
				view.textfield.text = '';
			}
		}
		
		
		/*
		-------------------------------------------------------------------------------------
		
			VIDEOPLAYER EVENTS
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * Registers all neccessary event listeners on the target videoPlayer.<br>
		 * Registered events:
		 * <ul>
		 * <li>LOAD</li>
		 * <li>PLAY</li>
		 * <li>PAUSE</li>
		 * <li>STOP</li>
		 * <li>SEEK</li>
		 * </ul>
		 */
		private function addPlayerEvents():void
		{
			main.videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			main.videoPlayer.addEventListener(VideoPlayerEvent.PLAY, handlePlayVideo);
			main.videoPlayer.addEventListener(VideoPlayerEvent.PAUSE, handlePauseVideo);
			main.videoPlayer.addEventListener(VideoPlayerEvent.STOP, handleStopVideo);
			main.videoPlayer.addEventListener(VideoPlayerEvent.SEEK, handleSeekVideo);
		}
		
		
		/**
		 * Removes all registered events from the target videoPlayer.
		 */
		private function removePlayerEvents():void
		{
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAY, handlePlayVideo);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PAUSE, handlePauseVideo);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.STOP, handleStopVideo);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.SEEK, handleSeekVideo);
		}
		
		protected function handlePlayerReady(event:Event):void
		{
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			if (_currentFile && timer && !timer.running) {
				timer.start();
			}
		}
		
		protected function handlePlayVideo(event:Event):void
		{
			if (_currentFile) timer.start();			
		}
		
		protected function handlePauseVideo(event:Event):void
		{
			timer.stop();
		}
		
		protected function handleStopVideo(event:Event):void
		{
			timer.stop();
		}
		
		protected function handleSeekVideo(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		
		
	}
}