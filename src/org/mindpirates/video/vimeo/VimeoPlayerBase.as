package org.mindpirates.video.vimeo
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.describeType;
	
	import org.mindpirates.video.VideoPlayerBase;
	import org.mindpirates.video.events.VideoPlayerEvent;
	
	/**
	 * <h3>VimeoPlayerBase</h3>
	 *
	 * <p>A wrapper class for Vimeo's video player (codenamed Moogaloop)
	 * that allows you to embed easily into any AS3 application.</p> 
	 * <p>Edited to extend <code>org.mindpirates.video.VideoPlayer</code> and be extended by <code>org.mindpirates.video.vimeo.VimeoPlayer</code>
	 * 
	 * <p>Example on how to use:
	 *  <code><pre>var vimeo_player = new VimeoPlayer([YOUR_APPLICATIONS_CONSUMER_KEY], 2, 400, 300);
	 *  vimeo_player.addEventListener(Event.COMPLETE, vimeoPlayerLoaded);
	 *  addChild(vimeo_player);</pre></code>
	 * </p>
	 * 
	 * <a href="http://vimeo.com/api/docs/moogaloop" target="_blank">http://vimeo.com/api/docs/moogaloop</a><br>
	 * <br>
	 * Register your application for access to the Moogaloop API at:<br>
	 * <br>
	 * <a href="http://vimeo.com/api/applications" target="_blank">http://vimeo.com/api/applications</a>
	 * 
	 * @author (Edited by) Jovica Aleksic (jovi@mindpirates.org)
	 */
	public class VimeoPlayerBase extends VideoPlayerBase {

		internal const MOOGALOOP_URL:String = "http://api.vimeo.com/moogaloop_api.swf";
		
		// Assets
		internal var container : Sprite      = new Sprite(); // sprite that holds the player
		internal var moogaloop : Object      = false;        // the player
		internal var player_mask : Sprite    = new Sprite(); // some sprites inside moogaloop go outside the bounds of the player. we use a mask to hide it
		
		// Default variables
		internal var player_width : int      = 400;
		internal var player_height : int     = 300;
		internal var api_version : int       = 2;
		internal var load_timer : Timer      = new Timer(200);
		
		// Events
		// API v2
		internal static const ERROR : String          = 'error';
		internal static const FINISH : String         = 'finish';
		internal static const LOAD_PROGRESS : String  = 'loadProgress';
		internal static const PAUSE : String          = 'pause';
		internal static const PLAY : String           = 'play';
		internal static const PLAY_PROGRESS : String  = 'playProgress';
		internal static const READY : String          = 'ready';
		internal static const SEEK : String           = 'seek';
		
		// API v1
		internal static const ON_FINISH : String      = 'onFinish';
		internal static const ON_LOADING : String     = 'onLoading';
		internal static const ON_PAUSE : String       = 'onPause';
		internal static const ON_PLAY : String        = 'onPlay';
		internal static const ON_PROGRESS : String    = 'onProgress';
		internal static const ON_SEEK : String        = 'onSeek';
		
		// runtime variables
		/**
		 * The ID of the current video.
		 */
		internal var _clip_id:int;
		
		public function VimeoPlayerBase(oauth_key:String, clip_id:int, w:int, h:int, fp_version:String='10', api_version:int=2)
		{
			this.setDimensions(w, h);
			
			Security.allowDomain('*');
			Security.allowInsecureDomain('*');
			
			var api_param : String = '&js_api=1';
			this.api_version = api_version;
			if (fp_version == '9')
			{
				this.api_version = 1;
			}
			
			api_param += '&api_version=' + this.api_version;
			
			var url:String = MOOGALOOP_URL 
								+ "?oauth_key=" + oauth_key 
								+ "&clip_id=" + clip_id 
								+ "&width=" + w 
								+ "&height=" + h 
								+ "&fullscreen=1"
								+ "&fp_version="+ fp_version 
								+ api_param 
								+ "&cache_buster=" + (new Date().time);
			
			var request : URLRequest = new URLRequest(url);
			
			var loaderContext : LoaderContext = new LoaderContext(true);
			
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			loader.load(request, loaderContext);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);

			_clip_id = clip_id;
			
			trace('VimeoPlayerBase', url);
		}
		
		override public function destroy() : void
		{
			trace(this, 'destroy()');
			if (api_version == 2)
			{
				// API v2 Event Handlers
				moogaloop.removeEventListener(ERROR, errorHandler);
				moogaloop.removeEventListener(READY, readyHandler);
				moogaloop.removeEventListener(PLAY, playHandler);
				moogaloop.removeEventListener(PAUSE, pauseHandler);
				moogaloop.removeEventListener(SEEK, seekHandler);
				moogaloop.removeEventListener(LOAD_PROGRESS, loadProgressHandler);
				moogaloop.removeEventListener(PLAY_PROGRESS, playProgressHandler);
				moogaloop.removeEventListener(FINISH, finishHandler);
			}
			else
			{
				// API v1 Event Handlers
				moogaloop.removeEventListener(ON_PLAY, onPlayHandler);
				moogaloop.removeEventListener(ON_PAUSE, onPauseHandler);
				moogaloop.removeEventListener(ON_SEEK, onSeekHandler);
				moogaloop.removeEventListener(ON_LOADING, onLoadingHandler);
				moogaloop.removeEventListener(ON_PROGRESS, onProgressHandler);
				moogaloop.removeEventListener(ON_FINISH, onFinishHandler);
			}
			
			moogaloop.destroy();
			if (container.contains(DisplayObject(moogaloop))) container.removeChild(DisplayObject(moogaloop));
			if (this.contains(player_mask)) this.removeChild(player_mask);
			if (this.contains(container)) this.removeChild(container);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		internal function setDimensions(w:int, h:int) : void
		{
			player_width  = w;
			player_height = h;
		}
		
		private function onComplete(e:Event) : void
		{
			
			trace(this , 'onComplete');
			
			
			// Finished loading moogaloop
			container.addChild(e.currentTarget.loader.content);
			moogaloop = e.currentTarget.loader.content;
			moogaloop.addEventListener(READY, readyHandler, false, 0, true);
			
			
			
			if (api_version == 2)
			{
				// API v2 Event Handlers
				moogaloop.addEventListener(PLAY, playHandler, false, 0, true);
				moogaloop.addEventListener(PAUSE, pauseHandler, false, 0, true);
				moogaloop.addEventListener(SEEK, seekHandler, false, 0, true);
				moogaloop.addEventListener(LOAD_PROGRESS, loadProgressHandler, false, 0, true);
				moogaloop.addEventListener(PLAY_PROGRESS, playProgressHandler, false, 0, true);
				moogaloop.addEventListener(FINISH, finishHandler, false, 0, true);
				trace('api v2 handlers attached')
			}
			else
			{
				// API v1 Event Handlers
				moogaloop.addEventListener(ON_PLAY, onPlayHandler, false, 0, true);
				moogaloop.addEventListener(ON_PAUSE, onPauseHandler, false, 0, true);
				moogaloop.addEventListener(ON_SEEK, onSeekHandler, false, 0, true);
				moogaloop.addEventListener(ON_LOADING, onLoadingHandler, false, 0, true);
				moogaloop.addEventListener(ON_PROGRESS, onProgressHandler, false, 0, true);
				moogaloop.addEventListener(ON_FINISH, onFinishHandler, false, 0, true);
				trace('api v1 handlers attached')
			}
			
			// Create the mask for moogaloop
			this.addChild(player_mask);
			container.mask = player_mask;
			this.addChild(container);
			
			redrawMask();
			
			load_timer.addEventListener(TimerEvent.TIMER, playerLoadedCheck);
			load_timer.start();
		}
		
		/**
		 * Wait for Moogaloop to finish setting up
		 */
		private function playerLoadedCheck(e:TimerEvent) : void
		{
			if (moogaloop.player_loaded)
			{
				// Moogaloop is finished configuring
				load_timer.stop();
				load_timer.removeEventListener(TimerEvent.TIMER, playerLoadedCheck);
				
				
				// remove moogaloop's mouse listeners listener
				moogaloop.disableMouseMove();
				if (stage)
				{
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
				}
				
				//trace(describeType(moogaloop));
				playerLoaded();
			}
		}
		
		/**
		 * Invoked once the player has been loaded.
		 */
		internal function playerLoaded():void
		{
			//dispatchEvent(createVideoPlayerEvent(VideoPlayerEvent.PLAYER_READY));
			dispatchEvent(new Event(Event.COMPLETE));
		}
		  
		/**
		 * Fake the mouse move/out events for Moogaloop
		 */
		private function mouseMove(e:MouseEvent) : void
		{
			if (moogaloop && moogaloop.player_loaded)
			{
				var pos : Point = this.parent.localToGlobal(new Point(this.x, this.y));
				if (e.stageX >= pos.x && e.stageX <= pos.x + this.player_width &&
					e.stageY >= pos.y && e.stageY <= pos.y + this.player_height)
				{
					moogaloop.mouseMove(e);
				}
				else
				{
					moogaloop.mouseOut();
				}
			}
		}
		
		private function redrawMask() : void
		{
			with (player_mask.graphics)
			{
				beginFill(0x000000, 1);
				drawRect(container.x, container.y, player_width, player_height);
				endFill();
			}
		}
		
		internal function doPlay():void
		{ 
			moogaloop.play();
		}
		
		internal function doPause():void
		{ 
			moogaloop.pause();
		}
		
		internal function doStop():void
		{
			seekTo(0);
			doPause();
		}
		
		/**
		 * Returns the hilight color of the player.
		 */
		public function getColor():*
		{
			return uint(moogaloop.color);
		}
		
		
		/**
		 * returns duration of video in seconds
		 */
		internal function getDuration() : int
		{
			return moogaloop.duration;
		}
		
		/**
		 * Seek to specific loaded time in video (in seconds)
		 */
		internal function seekTo(time:int) : void
		{
			moogaloop.seek(time);
		}
		
		/**
		 * Change the primary color (i.e. 00ADEF)
		 */
		internal function changeColor(hex:String) : void
		{
			moogaloop.color = uint('0x' + hex);
		}
		
		/**
		 * Load in a different video
		 */
		internal function loadVideo(id:int) : void
		{
			_clip_id = id;
			moogaloop.loadVideo(id);  
			doStop();
		}
		
		override public function setSize(w:int, h:int) : void
		{
			this.setDimensions(w, h);
			moogaloop.setSize(w, h);
			this.redrawMask();
		}
		
		/**
		 * ________________________________________________________________________________________________________
		 * 
		 * Event Handlers
		 * ________________________________________________________________________________________________________
		 * 
		 */
		internal function addedToStageHandler(event:Event) : void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		internal function removedFromStageHandler(event:Event) : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		/**
		 * ________________________________________________________________________________________________________
		 * 
		 * 		API v2 Event Handlers
		 * ________________________________________________________________________________________________________
		 * 
		 */
		
		 
		/**
		 * Fired when an error occurs in the player.<br>
		 * Data Properties
		 * <ul>
		 * <li>title:String; Title of error message.</li>
		 * <li>message:String; Message associated with the error.</li>
		 * <li>link:String; (optional) Link to either the video or information about why the error occurred.
		 * 		<br>NOTE: This property is only included when a link is associated with the error, so make sure to check for its existence before referencing.</li>
		 * </ul>
		 */
		internal function errorHandler(event:Event) : void
		{
			trace('errorHandler');
		}
		
		/**
		 * Fired as soon as the player has finished requesting the clip info and is ready for playback, either on the initial load of the player or after a loadVideo request.
		 */
		internal function readyHandler(event:Event) : void
		{
			trace(this, 'readyHandler()');
			dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.VIDEO_READY, event ) );
		}
		
		/**
		 * Fired when the video begins to play.
		 */
		internal function playHandler(event:Event) : void
		{
			trace('playHandler');
		}
		
		/**
		 * Fired when the video pauses.
		 */
		internal function pauseHandler(event:Event) : void
		{
			trace('pauseHandler');
		}
		
		/**
		 * Fired when the user seeks.<br>
		 * Data Properties
		 * <ul>
		 * <li>duration:Number; The duration of the video in seconds.</li>
		 * <li>percent:Number; The percent of the video that has been played.</li>
		 * <li>seconds:Number; The current time of playback for the video.</li>
		 * </ul>
		 */
		internal function seekHandler(event:Event) : void
		{
			trace('seekHandler');
		}
		
		 
		/**
		 * Fired as the video is loading.<br>
		 * Data Properties
		 * <ul>
		 * <li>bytesLoaded:Number; Number of bytes loaded for the video.</li>
		 * <li>bytesTotal:Number; Total number of bytes for the video.</li>
		 * <li>duration:Number; The duration of the video in seconds.</li>
		 * <li>percent:Number; The percent loaded of the video file.</li>
		 */
		internal function loadProgressHandler(event:Event) : void
		{
			trace('loadProgressHandler');
		}
			
		/**
		 * Fired as the video is playing.<br>
		 * Data Properties:
		 * <ul>
		 * <li>duration:Number; The duration of the video in seconds.</li>
		 * <li>percent:Number; The percent of the video that has been played.</li>
		 * <li>seconds:Number; The current time of playback for the video.</li>
		 */
		internal function playProgressHandler(event:Event) : void
		{
			trace('playProgressHandler');
		}
		
		/**
		 * Fires when the video playback reaches the end.
		 */
		internal function finishHandler(event:Event) : void
		{
			trace('finishHandler');
		}
		
		/**
		 * ________________________________________________________________________________________________________
		 * 
		 * 		API v1 Event Handlers
		 * ________________________________________________________________________________________________________
		 * 
		 */
		
		/**
		 * @copy #playHandler()
		 */
		internal function onPlayHandler(event:Event) : void
		{
			trace('onPlayHandler');
		}
		
		/**
		 * @copy #pauseHandler()
		 */
		internal function onPauseHandler(event:Event) : void
		{
			trace('onPauseHandler');
		}
		 
		
		/**
		 * @copy #seekHandler()
		 */
		internal function onSeekHandler(event:Event) : void
		{
			trace('onSeekHandler');
		}
		
		/**
		 * API v1 Load progress handler. Documentation may be imprecise.
		 * @see #loadProgressHandler()
		 */
		internal function onLoadingHandler(event:Event) : void
		{
			trace('onLoadingHandler');
		}
		
		
		/**
		 * API v1 play progress handler. Documentation may be imprecise.
		 * @see org.mindpirates.video.vimeo.VimeoPlayerBase#playProgressHandler() playProgressHandler()
		 */
		internal function onProgressHandler(event:Event) : void
		{
			trace('onProgressHandler');
		}
		
		/**
		 * @copy #finishHandler()
		 */
		internal function onFinishHandler(event:Event) : void
		{
			trace('onFinishHandler');
		}
	}
}