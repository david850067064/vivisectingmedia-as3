package com.vivisectingmedia.libtests.elements.selectiongroup
{
	import com.vivisectingmedia.framework.controllers.SelectionGroup;
	import com.vivisectingmedia.framework.controllers.abstracts.AbstractSelectableGroupItem;

	public class SelectionGroupObject extends AbstractSelectableGroupItem
	{
		
		// PRIVATE GET/SET PROPERTIES
		private var __selected:Boolean;
		
		public function SelectionGroupObject()
		{
			//TODO: implement function
			super();
		}
		/**
		 * The selected value is true for selected and false for deselected.
		 *  
		 * @param value
		 * 
		 */
		override public function set selected(value:Boolean):void
		{
			__selected = value;
		}
		
		override public function get selected():Boolean
		{
			return __selected;
		}
		
		override public function set group(value:SelectionGroup):void {
			super.group = value;
		}
		
		
	}
}