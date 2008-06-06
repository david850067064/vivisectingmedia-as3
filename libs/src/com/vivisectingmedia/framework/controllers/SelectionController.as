/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is ActionScript 3 SelectionController version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.controllers
{
	import com.vivisectingmedia.framework.controllers.interfaces.ISelectable;
	import com.vivisectingmedia.framework.datastructures.utils.HashTable;
	
	/**
	 * Provides a set of controls that allows any object that implement ISelectable to behave
	 * as a selection group.  This Controller allows a you to generate a group id and then
	 * group ISelectable items using this id value.  Once a group has been defined a you can then
	 * select a single item in the group and the other items will be deselected similarlary to a
	 * radio group, you can deselect all items or select items when using mutliple select.
	 * 
	 * <p>Items can be selected outside of the SelectionController and the selection of other items
	 * will not be modified unless the selection action is made through the SelectionController. This
	 * allows developers to create multi-selectable groupings and only when the selection of a specific
	 * item, group deselection or group selection is required should the SelectionController be used.</p>
	 *  
	 * @author James Polanco
	 * 
	 */
	public class SelectionController
	{
		/* STATIC PROPERTIES */
		static private var __instance:SelectionController;
		
		/* PRIVATE PROPERTIES */
		private var _groupId:int = 1;
		private var _itemTable:HashTable;
		private var _groupTable:HashTable;
		
		/* STATIC PUBLIC METHODS */
		/**
		 * Adds a Selectable item to a specificed group id.  The group id should be a unique id that 
		 * defines the group the item belongs to. Use the generateNewId() method on this class to 
		 * generate a unique that the id which is not in use within the manager.
		 * 
		 * <p>If an item is already assigne to a group id this method will remove the item from the
		 * previous group and re-assign the item to a new group.  Items can only be assigned to one
		 * group id within the SelectionController.</p>
		 *  
		 * @param item The item to add to the group.
		 * @param groupId The group id to add the item to.
		 * 
		 */
		static public function addItem(item:ISelectable, groupId:int):void
		{
			instance.inst_addItem(item, groupId);
		}
		
		/**
		 * Sets the selected property for the specified item and deselects any other items 
		 * within the same group as the specified item.  This method is responsible for looking
		 * up the group id for the specified item.  If the item is not within a defined group
		 * which is being tracked by the SelectionController then only the provided item will
		 * be selected and the any other items in the SelectionController will be unaffected.
		 * 
		 * @param item The item to select.
		 * 
		 */
		static public function selectItem(item:ISelectable):void
		{
			instance.inst_selectItem(item);
		}
		
		/**
		 * Used to deselect all items in a selection group. This
		 * method sets the selected value on all the group items to false.
		 * 
		 * @param group
		 * 
		 */
		static public function deselectAll(group:int):void
		{
			instance.inst_deselectAll(group);
		}
		
		/**
		 * Used to select all the items within a selection group. This 
		 * method sets the selected value on all the group items to true.
		 *  
		 * @param group The selection group to select.
		 * 
		 */
		static public function selectAll(group:int):void
		{
			instance.inst_selectAll(group);
		}
		
		/**
		 * Returns the specified item's group id number.  This method looks
		 * up the item in the SelectionController and provides the group id
		 * that is currently assigned to an item.  If the item is not being
		 * tracked / assigned to a group id then the value -1 is returned which
		 * represents no group id.
		 *  
		 * @param item Item to look group up on.
		 * @return The group the item is a member of.
		 * 
		 */
		static public function getItemGroup(item:ISelectable):int
		{
			return instance.inst_getItemGroup(item);
		}
		
		/**
		 * Removes the item from the manager and the boung group.  If the item is the 
		 * last of the group, the group is removed from the SelectionController and is
		 * no longer considered a valid group id.  The group id can be re-used when calling
		 * addItem() but verify that the no other items are assigned to the group at the
		 * time of reuse.
		 *  
		 * @param item The item to remove from the group.
		 * 
		 */
		static public function removeItem(item:ISelectable):void
		{
			instance.inst_removeItem(item);
		}
		
		/**
		 * Removes all the items and the group id from the controller.
		 *  
		 * @param groupId The group to remove the items from.
		 * 
		 */
		static public function removeAllItems(groupId:int):void
		{
			instance.inst_removeAllItems(groupId);
		}
		
		/**
		 * This method removes all items and groups from the SelectionController.  This
		 * method is considered a full reset and removes all references and group ids
		 * from the instance. 
		 * 
		 */
		static public function clearAllGroups():void
		{
			instance.inst_clearAllGroups();
		}
		
		/**
		 * Used to generate a unique group id.  This should be called when creating a new g
		 * rouping to verify that the provided id is unique in the system.
		 *  
		 * @return A unique generated group id. 
		 * 
		 */
		static public function generateNewId():int
		{
			return instance.inst_generateNewId();
		}
		
		/* STATIC PRIVATE METHODS */
		static private function get instance():SelectionController
		{
			if(!__instance) __instance = new SelectionController(new SingletonLock());
			return __instance;
		}
		
		/* PUBLIC METHODS */
		/**
		 * DO NOT CALL.
		 * 
		 * @private 
		 * @param lock
		 * 
		 */
		public function SelectionController(lock:SingletonLock)
		{
			// CONSTRUCTOR
			_groupTable = new HashTable();
			_itemTable = new HashTable();
		}
		
		/* PRIVATE METHODS */
		/**
		 * Method called by the public facade method addItem().
		 *  
		 * @param item
		 * @param groupId
		 * 
		 */		
		private function inst_addItem(item:ISelectable, groupId:int):void
		{
			if(_itemTable.containsKey(item)) removeItem(item); // remove item from existing group
			_itemTable.addItem(item, groupId);
			
			if(_groupTable.containsKey(groupId))
			{
				// add to the existing group
				var groupList:Array = _groupTable.getItem(groupId) as Array;
				groupList.push(item);
			} else {
				// create group then add
				_groupTable.addItem(groupId, new Array(item));
			}
		}
		
		/**
		 * Method called by the public facade method selectItem(). 
		 * @param item
		 * 
		 */
		private function inst_selectItem(item:ISelectable):void
		{
			// get all the items in the group
			if(!_itemTable.containsKey(item))
			{
				// select the item but return, not grouped.
				item.selected = true;
				return;
			}
			var itemList:Array = _groupTable.getItem(_itemTable.getItem(item)) as Array;
			
			// select the item, deselect the rest 
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				var currentItem:ISelectable = ISelectable(itemList[i]);
				currentItem.selected = (currentItem == item) ? true : false;
			}
		}
		
		/**
		 * Method called by the public facade method deselectAll(). 
		 * @param group
		 * 
		 */
		private function inst_deselectAll(group:int):void
		{
			// get all the items in the group
			if(!_groupTable.containsKey(group)) return; // not in the queue
			var itemList:Array = _groupTable.getItem(group) as Array;
			
			// select the item, deselect the rest 
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				ISelectable(itemList[i]).selected = false;
			}
		}
		
		/**
		 * Method called by the public facade method selectAll(). 
		 * @param group
		 * 
		 */
		private function inst_selectAll(group:int):void
		{
			if(!_groupTable.containsKey(group)) return; // not in queue
			var itemList:Array = _groupTable.getItem(group) as Array;
			
			// select the item, deselect the rest 
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				ISelectable(itemList[i]).selected = true;
			}
		}
		
		/**
		 * Method called by the public facade method getItemGroup(). 
		 * @param item
		 * @return 
		 * 
		 */
		private function inst_getItemGroup(item:ISelectable):int
		{
			var group:int = -1;
			if(_itemTable.containsKey(item)) group = _itemTable.getItem(item);
			return group;
		}
		
		/**
		 * Method called by the public facade method removeItem(). 
		 * @param item
		 * 
		 */
		private function inst_removeItem(item:ISelectable):void
		{
			// verify we have the item
			if(!_itemTable.containsKey(item)) return;
			
			// remove the item from the tables
			var group:int = _itemTable.getItem(item);
			var itemList:Array = _groupTable.getItem(group) as Array;
			
			// find the item, remove it
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				if(itemList[i] == item)
				{
					itemList.splice(i, 1);
					break;
				}
			}
			
			// remove from the itemtable
			_itemTable.remove(item);
			
			// see if there are any more items, if not remove the group
			if(itemList.length < 1) _groupTable.remove(group);

		}
		
		/**
		 * Method called by the public facade method removeAllItems(). 
		 * @param groupId
		 * 
		 */
		private function inst_removeAllItems(groupId:int):void
		{
			// get the group, remove the items
			if(!_groupTable.containsKey(groupId)) return;
			var itemList:Array = _groupTable.getItem(groupId) as Array;
			
			// find the item, remove it from the itemTable
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				_itemTable.remove(ISelectable(itemList[i]));
			}
			
			// remove the group
			_groupTable.remove(groupId);
		}
		
		/**
		 * Method called by the public facade method clearAllGroups();
		 * 
		 */
		private function inst_clearAllGroups():void
		{
			_itemTable.removeAll();
			_groupTable.removeAll();
			_groupId = 1;
		}
		
		/**
		 * Method called by the public facade method generateNewId(). 
		 * @return 
		 * 
		 */
		private function inst_generateNewId():int
		{
			return _groupId++;
		}
	}
}

class SingletonLock
{
	public function SingletonLock():void {}
}