package com.vivisectingmedia.flogpanel.ui
{
	import mx.controls.Label;

	public class DateFieldRender extends Label
	{
		public function DateFieldRender()
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value.hasOwnProperty("time"))
			{
				this.text = formatTime(value.time as Date)
			}
		}
		
		protected function formatTime(time:Date):String
		{
			var hours:String = time.getHours().toString();
			var minutes:String = time.getMinutes().toString();
			var seconds:String = time.getSeconds().toString();
			var milliseconds:String = time.getMilliseconds().toString();
			
			return (hours + ":" + minutes + ":" + seconds + "." + milliseconds);
		}
		
	}
}