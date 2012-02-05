package org.mindpirates.video.vimeo
{
	import org.mindpirates.video.VideoServices;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.SubtitleVideoPlayer;

	public class VimeoSubtitlePlayer extends SubtitleVideoPlayer
	{
		/**
		 * The vimeo id for PROBLEMA.
		 * @default: 17712557
		 */
		private const DEFAULT_VIDEO_ID:String = '17712557';
		
		public function VimeoSubtitlePlayer()
		{
			super(); 
		}
		
		override public function createPlayer():void
		{
			var oauth:String = 			VimeoAuth.OAUTH_KEY;
			var clip_id:String = 		flashVars.video_id || DEFAULT_VIDEO_ID;
			var w:Number = 				stage.stageWidth;
			var h:Number = 				stage.stageHeight;
			var fp_version:String = 	'11';
			videoPlayer = new VimeoPlayer(oauth, clip_id, w, h, fp_version);
			addChild(videoPlayer.displayObject);
			super.createPlayer();
		}
	}
}