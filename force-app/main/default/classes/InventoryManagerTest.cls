@isTest
private class InventoryManagerTest {

    @isTest
    static void testAddNewItem() {
        InventoryManager im = new InventoryManager();

        im.addItem('Laptop', 10);

        System.assertEquals(10, im.getQuantity('Laptop'));
    }

    @isTest
    static void testAddExistingItem() {
        InventoryManager im = new InventoryManager();

        im.addItem('Laptop', 10);
        im.addItem('Laptop', 5);

        System.assertEquals(15, im.getQuantity('Laptop'));
    }

    @isTest
    static void testRemoveItemNormal() {
        InventoryManager im = new InventoryManager();

        im.addItem('Mouse', 10);
        im.removeItem('Mouse', 4);

        System.assertEquals(6, im.getQuantity('Mouse'));
    }

    @isTest
    static void testRemoveMoreThanExists() {
        InventoryManager im = new InventoryManager();

        im.addItem('Keyboard', 5);
        im.removeItem('Keyboard', 10);

        System.assertEquals(0, im.getQuantity('Keyboard'));
    }

    @isTest
    static void testRemoveNonExistingItem() {
        InventoryManager im = new InventoryManager();

        im.removeItem('Monitor', 5);

        System.assertEquals(0, im.getQuantity('Monitor'));
    }

    @isTest
    static void testGetQuantityNonExisting() {
        InventoryManager im = new InventoryManager();

        System.assertEquals(0, im.getQuantity('Unknown'));
    }

    @isTest
    static void testNullInputs() {
        InventoryManager im = new InventoryManager();

        im.addItem(null, 10);
        im.addItem('Item', null);
        im.addItem('Item', -5);

        im.removeItem(null, 5);
        im.removeItem('Item', null);
        im.removeItem('Item', -3);

        System.assertEquals(0, im.getQuantity(null));
    }
}