package org.mindpirates.video.subs
{
	import embed.fonts.EmbeddedFonts;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.mindpirates.video.events.SubtitleEvent;
	import org.mindpirates.video.events.SubtitleFileLoaderEvent;
	import org.mindpirates.video.events.SubtitleListLoaderEvent;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.loading.SubsListLoader;
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	import org.mindpirates.video.subs.view.SubtitleTextField;
	import org.mindpirates.video.subs.view.SubtitlesView;
	
	import utils.StringUtils;
	 
	 
	/**
	 * This class displays subtitles for a videoPlayer.<br> 
	 * It creates the view containing a textfield and UI elements and a timer-based controller.
	 */
	public class Subtitles
	{
		  
		/**
		 * The SubtitlesList that loads the XML file containing paths to individual subtitle files.
		 */
		private var listLoader:SubsListLoader;

		/**
		 * A Sprite that holds required UI elements.
		 */
		//private var ui:SubtitlesUI;
		 
		
		/**
		 * Embeds the required fonts.
		 * @see org.mindpirates.video.subs.Fonts
		 */
		public static var fonts:EmbeddedFonts = new EmbeddedFonts();
		
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
		public var view:SubtitlesView;
		
		/**
		 * The currently displayed subtitle line
		 */
		private var _currentSubtitleLine:SubtitleLine; 
		
		
		private var textScale:Number = 1;
		private var textScaleDelta:Number = 0.1;
		
		/**
		 * @param vars The flashvars passed from the HTML page
		 */
		public function Subtitles(target:SubtitleVideoPlayer)
		{
			super();  
			EmbeddedFonts
			_main = target; 
			addPlayerEvents();
			createTimer();		
			createView();
			initJS();
			if (main.flashVars.subtitlesList) {
				loadSubtitlesList(main.flashVars.subtitlesList);
			}
			else {
				throw new Error('No subtitle list specified in flashvars!')
			}
		}
		
		private function initJS():void
		{
			if (ExternalInterface.available) {
				ExternalInterface.addCallback('list', loadSubtitlesList);
				ExternalInterface.addCallback('subtitles', loadSubtitlesJS);
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
			view.destroy();
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
			
			// init UI elements
			if (main.flashVars.subtitlesList) {
				view.ui.comboBox.addEventListener(Event.CHANGE, handleSelectFileChange);			
			}
			else{
				view.ui.comboBox.visible = false;
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
			listLoader = new SubsListLoader();
			listLoader.addEventListener(SubtitleListLoaderEvent.LOAD_ERROR, handleSubtitlesListError);
			listLoader.addEventListener(SubtitleListLoaderEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			listLoader.load(new URLRequest(file+'?time='+new Date().time));
		}
		
		protected function handleSubtitlesListError(event:SubtitleListLoaderEvent):void
		{
			listLoader.removeEventListener(SubtitleListLoaderEvent.LOAD_ERROR, handleSubtitlesListError);
			listLoader.removeEventListener(SubtitleListLoaderEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			trace('failed loading subtitlelist', event.originalEvent);
		}		
		
		
		protected function handleSubtitlesListComplete(event:Event):void
		{
			listLoader.removeEventListener(SubtitleListLoaderEvent.LOAD_ERROR, handleSubtitlesListError);
			listLoader.removeEventListener(SubtitleListLoaderEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			view.ui.comboBox.dataProvider = view.ui.comboBox.createDataProvider(listLoader.files);
			loadDefaultSubtitles();
		}		
		
		protected function handleSelectFileChange(event:Event):void
		{
			//trace(this, 'handleSelectFileChange', view.ui.comboBox.selectedItem.label);
			var fileLoader:SubtitleFileLoader = view.ui.comboBox.selectedItem.fileLoader;
			if (!fileLoader.fileURL) {
				clearSubtitles();
			}
			else {
				if (!fileLoader.isLoaded) {
					loadSubtitles( fileLoader );
				}
				else { 
					displaySubtitles(fileLoader);
				}
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
			fileLoader.addEventListener(SubtitleFileLoaderEvent.COMPLETE, handleSubtitleFileLoaded);
			fileLoader.load();
			var event:SubtitleEvent = new SubtitleEvent(SubtitleEvent.FILE_LOAD);
			event.file = fileLoader;
			main.dispatchEvent(event);
		}
		
		/**
		 * Loads a subtitles file. This function is made available to JS via ExternalInterface.
		 */
		public function loadSubtitlesJS(id:String):void
		{
			var file:SubtitleFileLoader;
			for each(var f:SubtitleFileLoader in listLoader.files) {
				if (f.id == id) {
					file = f;
				}
			}
			if (file) {
				loadSubtitles(file);
			}
		}
		
		
		/**
		 * Handles loading success of a subtitle file and diplays it.
		 */
		protected function handleSubtitleFileLoaded(event:Event):void
		{
			var file:SubtitleFileLoader = event.target as SubtitleFileLoader;
			file.removeEventListener(SubtitleFileLoaderEvent.COMPLETE, handleSubtitleFileLoaded);
			
			displaySubtitles(file);
		}
		 
		
		private function clearSubtitles():void
		{
			if (timer.running) {
				timer.stop();
			}
			_currentFile = null;
			_currentSubtitleLine = null;
			setSubtitleLine(null);			
		}
		
		/**
		 * Displays the subtitles of a loaded <code>SubtitleFileLoader</code>.
		 * @param file A <code>SubtitleFileLoader</code> that contains the subtitles.
		 */
		private function displaySubtitles(file:SubtitleFileLoader):void
		{ 
			
			trace(this, 'displaySubtitles', file,'('+file.fileURL+', '+file.fontFile+')');
			
			
			_currentFile = file;
			_currentSubtitleLine = null;
			 
			
			// change the selected item of the selection combobox to display the new file 
			var listIndex:int = view.ui.comboBox.getFileIndex( file );
			if (listIndex > -1) {
				view.ui.comboBox.selectedIndex = listIndex;
			}
			
			
			// start the timer
			if (main.videoPlayer.isReady && !timer.running) {
				timer.start();
			}
			
			
			//trace(this, 'file loaded', 'fontSize: ' + file.fontSize, 'effective fontsize: ', (file.fontSize ? file.fontSize : SubtitleTextField.defaultFontSize))
			// reset the font
			view.subtitlesTextField.fontSize = textScale * (file.fontSize ? file.fontSize : SubtitleTextField.defaultFontSize); 
			view.subtitlesTextField.fontName = file.fontName ? file.fontName : SubtitleTextField.defaultFontName;
			
			updateSubtitleLine();
			
		}
		
		public function get currentFile():SubtitleFileLoader
		{
			return _currentFile;
		}
		
		
		public function get currentLine():SubtitleLine
		{
			return _currentSubtitleLine;
		}
		
		/**
		 * Attempts to load the default subtitle file. This can be overridden via flashvars:
		 * <ol>
		 * <li>if a 'subtitles' property was specified in the flashvars, and the value corresponds to either the ID or URL of an item in the XML list, that file will be used.</li>
		 * <li>if no file was determined based on the flashvars, the file specified by the "default_id" attribute of the root node in the XML list will be used.</li>
		 * <li>if both previous attempts fail, and the XML list contains at least one item, the file specified by the first XML item will be used.</li>
		 * </ol>
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
		
		
		/*
		-------------------------------------------------------------------------------------
		
		TIMER
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * Creates the <code>timer</code> and registers the <code>TimerEvent.TIMER</code> event listener to update the view.
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
			updateSubtitleLine();			
		}
		
		private function updateSubtitleLine():void
		{
			
			if (!_currentFile) {
				_currentSubtitleLine = null;
				setSubtitleLine(null);
				return;
			}
			
			var file:SubtitleFileLoader = _currentFile;
			var line:SubtitleLine = file.subtitles.getLineAtTime( main.videoPlayer.positionTime ); 
			
			if (!line && !_currentSubtitleLine) {
				return;
			}
			
			if (!line && _currentSubtitleLine) {
				setSubtitleLine(null);
				return;
			}
			
			if ( (line && line == _currentSubtitleLine)) {
				return;
			}
			
			setSubtitleLine(line);
		}
		
		private function setSubtitleLine(line:SubtitleLine):void
		{
		
			if (!line) {
				clearSubtitleLine();
			}
			else {
				trace('setSubtitleLine()', StringUtils.videoTime(main.videoPlayer.positionTime));
				trace(line.text, StringUtils.videoTime(line.start), StringUtils.videoTime(line.end))
				
				var event:SubtitleEvent = new SubtitleEvent( SubtitleEvent.LINE_CHANGED );
				event.file = _currentFile;
				event.oldLine = _currentSubtitleLine;
				event.newLine = line;
				event.text = line.text;
				
				view.subtitlesTextField.text = line.text;
				_currentSubtitleLine = line;
				
				main.dispatchEvent( event );
			}
			
		}		
		private function clearSubtitleLine(): void
		{
			trace('clearSubtitleLine()', StringUtils.videoTime(main.videoPlayer.positionTime));
			
			var event:SubtitleEvent = new SubtitleEvent( SubtitleEvent.LINE_CLEARED );
			event.file = _currentFile;
			event.oldLine = _currentSubtitleLine;
			event.text = '';
			
			view.subtitlesTextField.text = '';
			_currentSubtitleLine = null;
			
			main.dispatchEvent( event );
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
			trace(this, 'addPlayerEvents()');
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
			trace(this, 'removePlayerEvents()');
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAY, handlePlayVideo);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PAUSE, handlePauseVideo);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.STOP, handleStopVideo);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.SEEK, handleSeekVideo);
		}
		
		protected function handlePlayerReady(event:Event):void
		{
			trace(this, 'handlePlayerReady()', event, event.target);
			main.videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			if (_currentFile && timer && !timer.running) {
				timer.start();
			}
		}
		
		protected function handlePlayVideo(event:Event):void
		{
			trace(this, 'handlePlayVideo()');
			if (_currentFile) {
				timer.start();
				updateSubtitleLine();
			}
		}
		
		protected function handlePauseVideo(event:Event):void
		{
			trace(this, 'handlePauseVideo()');
			timer.stop();
		}
		
		protected function handleStopVideo(event:Event):void
		{
			trace(this, 'handleStopVideo()');
			timer.stop();
		}
		
		protected function handleSeekVideo(event:Event):void
		{
			trace(this, 'handleSeekVideo()');
			updateSubtitleLine();			
		}
		
		public function increaseTextSize(e:Event=null):void
		{
			textScale += textScaleDelta;
			view.subtitlesTextField.fontSize = textScale * (currentFile && currentFile.fontSize ? currentFile.fontSize : SubtitleTextField.defaultFontSize);
			view.layout();
		}
		public function decreaseTextSize(e:Event=null):void
		{
			textScale -= textScaleDelta;
			if (textScale < 0.5) {
				textScale = 0.5;
			}
			view.subtitlesTextField.fontSize = textScale * (currentFile && currentFile.fontSize ? currentFile.fontSize : SubtitleTextField.defaultFontSize); 
			view.layout();
		}
		
	}
}