trigger ProductTrigger on Product2 (after insert) {
    SFCC_ProductAdd_API.addProduct_To_SFCC(Trigger.new);
}