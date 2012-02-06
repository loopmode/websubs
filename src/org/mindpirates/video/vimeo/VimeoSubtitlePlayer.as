package org.mindpirates.video.vimeo
{
	import org.mindpirates.video.subs.VideoServices;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.SubtitleVideoPlayer;
	
	
	[SWF(width="640", height="360", backgroundColor="0x000000")]
	
	/**
	 * The <code>VimeoSubtitlePlayer</code> is an implementation of <code>SubtitleVideoPlayer</code> for the Moogaloop videoplayer from vimeo.com.
	 * @see org.mindpirates.video.subs.SubtitleVideoPlayer
	 */
	public class VimeoSubtitlePlayer extends SubtitleVideoPlayer
	{
		
		public function VimeoSubtitlePlayer()
		{
			super();
			setVideoService( VideoServices.VIMEO );
		}
		
		override public function createPlayer():void
		{
			var oauth:String 			= VimeoAuth.OAUTH_KEY;
			var clip_id:String 			= flashVars.video_id;
			var w:Number 				= stage.stageWidth;
			var h:Number 				= stage.stageHeight;
			var fp_version:String 		= '11';
			videoPlayer = new VimeoPlayer(oauth, clip_id, w, h, fp_version);
			addChild(videoPlayer.displayObject);
			super.createPlayer();
		}
	}
}