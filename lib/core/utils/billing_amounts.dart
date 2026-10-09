const maxExactPaise = 9007199254740991;

bool validBillAmounts(double quantity, double rate) =>
    quantity.isFinite && quantity > 0 && rate.isFinite && rate >= 0 &&
    31 * quantity * rate * 100 <= maxExactPaise;
