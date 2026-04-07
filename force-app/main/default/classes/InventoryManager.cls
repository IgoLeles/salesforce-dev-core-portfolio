public class InventoryManager {

    private class Item {
        public String name;
        public Integer quantity;

        public Item(String name, Integer quantity) {
            this.name = name;
            this.quantity = quantity;
        }
    }

    private Map<String, Item> inventory = new Map<String, Item>();

    public void addItem(String itemName, Integer quantity) {
        if (itemName == null || quantity == null || quantity <= 0) {
            return;
        }

        if (inventory.containsKey(itemName)) {
            inventory.get(itemName).quantity += quantity;
        } else {
            inventory.put(itemName, new Item(itemName, quantity));
        }
    }

    public void removeItem(String itemName, Integer quantity) {
        if (itemName == null || quantity == null || quantity <= 0) {
            return;
        }

        if (!inventory.containsKey(itemName)) {
            return;
        }

        Item item = inventory.get(itemName);

        if (quantity >= item.quantity) {
            item.quantity = 0;
        } else {
            item.quantity -= quantity;
        }
    }

    public Integer getQuantity(String itemName) {
        if (itemName == null || !inventory.containsKey(itemName)) {
            return 0;
        }

        return inventory.get(itemName).quantity;
    }
}