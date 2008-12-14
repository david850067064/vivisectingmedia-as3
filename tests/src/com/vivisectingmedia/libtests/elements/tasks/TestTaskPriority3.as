package com.vivisectingmedia.libtests.elements.tasks
{
	import com.vivisectingmedia.framework.controllers.abstracts.AbstractTask;

	public class TestTaskPriority3 extends TestTask
	{
		public static const TYPE:String = "Priority_three";
		public static const PRIORITY:int = 3;
		
		public function TestTaskPriority3(type:String="", priority:int=5)
		{
			super(TestTaskPriority3.TYPE, TestTaskPriority3.PRIORITY);
		}			
	}
}