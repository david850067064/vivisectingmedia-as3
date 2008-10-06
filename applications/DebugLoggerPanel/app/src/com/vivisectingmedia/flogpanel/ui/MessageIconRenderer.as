package com.vivisectingmedia.flogpanel.ui
{
	import com.vivisectingmedia.framework.utils.logging.DebugMessage;
	
	import mx.containers.Canvas;
	import mx.controls.Image;

	public class MessageIconRenderer extends Canvas
	{
		[Embed(source="./assets/info_icon.png")]
		public var infoIconAsset:Class;
		
		[Embed(source="./assets/debug_icon.png")]
		public var debugIconAsset:Class;
		
		[Embed(source="./assets/warn_icon.png")]
		public var warnIconAsset:Class;
		
		[Embed(source="./assets/error_icon.png")]
		public var errorIconAsset:Class;
		
		[Embed(source="./assets/fatal_icon.png")]
		public var fatalIconAsset:Class;
		
		protected var img:Image;
		protected var __data:Object;
		protected var _showImage:Boolean = true;
		
		public function MessageIconRenderer()
		{
			super();
			img = new Image();
			img.setStyle("horizontalCenter", 0);
			img.setStyle("verticalCenter", 0);
		}
		
		override public function initialize():void
		{
			super.initialize();
			if(__data && !_showImage)
			{
				this.removeAllChildren();
			} else {
				this.addChild(img);
			}
			
		}
		
		override public function set data(value:Object):void
		{
			__data = value;
			if(value.hasOwnProperty("type"))
			{
				switch(value.type)
				{
					case DebugMessage.INFO:
						_showImage = true;
						img.source = infoIconAsset;
					break;
					
					case DebugMessage.DEBUG:
						_showImage = true;
						img.source = debugIconAsset;
					break;
					
					case DebugMessage.WARN:
						_showImage = true;
						img.source = warnIconAsset;
					break;
					
					case DebugMessage.ERROR:
						_showImage = true;
						img.source = errorIconAsset;
					break;
					
					case DebugMessage.FATAL:
						_showImage = true;
						img.source = fatalIconAsset;
					break;
					
					default:
						_showImage = false;
				}
			}
			
			if(_showImage && !this.contains(img)) 
			{
				this.addChild(img)
			} else if(!_showImage) {
				this.removeAllChildren();
			}
		}
		
	}
}