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
 * The Original Code is ActionScript 3 HashTableTests version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests.tests
{
	import com.vivisectingmedia.framework.datastructures.utils.HashTable;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * This Suite tests all the functionality of the HashTable and verifies
	 * that the HashTable behaves as designed.
	 * @author James Polanco
	 * 
	 */
	public class HashTableTests extends TestCase
	{
		/**
		 * Static method that creates the default suite of tests.
		 *  
		 * @return The active suite for the HashTableTests.
		 * 
		 */
		public static function suite():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			
			ts.addTest(new HashTableTests("testAddAndRetrieveItem"));
			ts.addTest(new HashTableTests("testSameItemWithDifferentKeys"));
			ts.addTest(new HashTableTests("testAddItemsUsingTheSameKey"));
			ts.addTest(new HashTableTests("testAddAndRemoveItem"));
			ts.addTest(new HashTableTests("testAddRemoveSameItemDifferentKeys"));
			ts.addTest(new HashTableTests("testAddMultipleItemsThenRemoveAll"));
			ts.addTest(new HashTableTests("testAddKeyCheckPosition"));
			ts.addTest(new HashTableTests("testAddItemsGetAllItems"));
			ts.addTest(new HashTableTests("testAddKeysGetAllKeys"));
			ts.addTest(new HashTableTests("testVerifyExistingItems"));
			ts.addTest(new HashTableTests("testVerifyNonExistingItems"));
			ts.addTest(new HashTableTests("testVerifyExistingKeys"));
			ts.addTest(new HashTableTests("testVerifyNonExistingKeys"));
			ts.addTest(new HashTableTests("testIsEmpty"));
			ts.addTest(new HashTableTests("testLength"));
			
			return ts;
		}
		
		/**
		 * TestCase Constructor.
		 *  
		 * @param methodName Test method to run.
		 * 
		 */
		public function HashTableTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * verifies that items can be added to the HashTable and then 
		 * retrieved using the provided key 
		 * 
		 */
		public function testAddAndRetrieveItem():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var item1:Object = {id: "item1"};
			var key2:Object = {id: "key2"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item2 == hash.getItem(key2)));
		}
		
		/**
		 * Verifies that the same item can be added twice with different keys
		 * and also that the item can be retrieved using the different keys 
		 * 
		 */
		public function testSameItemWithDifferentKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key2)));
		}
		
		/**
		 * verifies that when adding different items with the same key 
		 * overwrites the original key/item pair 
		 * 
		 */
		public function testAddItemsUsingTheSameKey():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			
			// add item2 using key 1
			hash.addItem(key1, item2);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item2 == hash.getItem(key1)));
		}
		
		/**
		 * verifies that an item that is added by a key is then removed 
		 * from the HashTable with the key 
		 * 
		 */
		public function testAddAndRemoveItem():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var item1:Object = {id: "item1"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			
			// remove the item and verify that it is gone
			hash.remove(key1);
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key1));
		}
		
		/**
		 * verifies that an item which is in the HashTable multiple times 
		 * can be removed by the specific key provided 
		 * 
		 */
		public function testAddRemoveSameItemDifferentKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key2)));
			
			// remove the item and verify that it is gone
			hash.remove(key1);
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key1));
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key2)));
			
			hash.remove(key2);
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key2));
		}
		
		/**
		 * verifies that adding multiple items then calling removeAll() clears the HashTable. 
		 * 
		 */
		public function testAddMultipleItemsThenRemoveAll():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// get the items
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item2 == hash.getItem(key2)));
			assertTrue("The retrieved item does not match the item put in.",(item3 == hash.getItem(key3)));
			
			// remove all
			hash.removeAll();
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key1));
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key2));
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key3));
		}
		
		/**
		 * verify that adding key pairs and then requesting locations 
		 * returns the correct key 
		 * 
		 */
		public function testAddKeyCheckPosition():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// check the position
			assertTrue("The retrieved item does not match the item put in.",(key1 == hash.getKeyAt(0)));
			assertTrue("The retrieved item does not match the item put in.",(key2 == hash.getKeyAt(1)));
			assertTrue("The retrieved item does not match the item put in.",(key3 == hash.getKeyAt(2)));
		}
		
		/**
		 * verify that calling getAllItmes() returns all the items 
		 * that have been added to the Hashtable in the order they where
		 * added.
		 * 
		 */
		public function testAddItemsGetAllItems():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// check that we got all the items back
			var list:Array = hash.getAllItems();
			
			assertTrue("The list of items count is not correct.", list.length == 3);
			assertTrue("The retrieved item does not match the item put in.",(item1 == list[0]));
			assertTrue("The retrieved item does not match the item put in.",(item2 == list[1]));
			assertTrue("The retrieved item does not match the item put in.",(item3 == list[2]));
		}
		
		/**
		 * verify that adding multiple pairs returns all the keys that have been added 
		 * 
		 */
		public function testAddKeysGetAllKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// check that we got all the items back
			var list:Array = hash.getAllKeys();
			
			assertTrue("The list of items count is not correct.", list.length == 3);
			assertTrue("The retrieved item does not match the item put in.",(key1 == list[0]));
			assertTrue("The retrieved item does not match the item put in.",(key2 == list[1]));
			assertTrue("The retrieved item does not match the item put in.",(key3 == list[2]));
		}
		
		/**
		 * verify that the HashTable properly identifies an existing item in the table
		 * 
		 */
		public function testVerifyExistingItems():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Item should exist.", hash.containsItem(item1));
			assertTrue("Item should exist.", hash.containsItem(item2)); 
			
			// remove the item and verify that it no longer contains the key
			hash.remove(key1);
			assertFalse("Key should not exist.", hash.containsItem(item1));
		}
		
		/**
		 * verifies that the HashTable properly returns a negative response 
		 * for a non-existing item
		 * 
		 */
		public function testVerifyNonExistingItems():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Item should exist.", hash.containsItem(item1));
			assertTrue("Item should exist.", hash.containsItem(item2)); 
			assertFalse("Item should not exist.", hash.containsItem(item3)); 
		}
		
		/**
		 * verify that the HashTable properly identifies an existing key in the table
		 * 
		 */
		public function testVerifyExistingKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Key should exist.", hash.containsKey(key1));
			assertTrue("Key should exist.", hash.containsKey(key2));
			
			// remove the item and verify that it no longer contains the key
			hash.remove(key1);
			assertFalse("Key should not exist.", hash.containsKey(key1));
		}
		
		/**
		 * verifies that the HashTable properly returns a negative response 
		 * for a non-existing key
		 * 
		 */
		public function testVerifyNonExistingKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Key should exist.", hash.containsKey(key1));
			assertTrue("Key should exist.", hash.containsKey(key2)); 
			assertFalse("Key should not exist.", hash.containsItem(key3)); 
		}
		
		/**
		 * verifies that the hashtable responds with the proper value 
		 * when the item is empty and when it contains items
		 * 
		 */
		public function testIsEmpty():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// verify the hash table returns empty
			assertTrue("The HashTable should be empty.", hash.isEmpty);
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify the table is not empty
			assertFalse("The HashTable should not be empty.", hash.isEmpty);
			
			// remove all then verify that the table is empty
			hash.removeAll();
			assertTrue("The HashTable should be empty.", hash.isEmpty);
		}
		
		/**
		 * verifies that the correct length is returned for the content. 
		 * 
		 */
		public function testLength():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// verify the hash table returns empty
			assertTrue("The HashTable length should be 0.", hash.length == 0);
			
			// add the pair to the table and verify length
			hash.addItem(key1, item1);
			assertTrue("The HashTable length should be 1.", hash.length == 1);
			
			hash.addItem(key2, item2);
			assertTrue("The HashTable length should be 2.", hash.length == 2);
			
			hash.addItem(key3, item3);
			assertTrue("The HashTable length should be 3.", hash.length == 3);
			
			// remove one by onw and verify length
			hash.remove(key3);
			assertTrue("The HashTable length should be 2.", hash.length == 2);
			hash.remove(key2);
			assertTrue("The HashTable length should be 1.", hash.length == 1);
			hash.remove(key1);
			assertTrue("The HashTable length should be 0.", hash.length == 0);
		}
	}
}