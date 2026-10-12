# Synthetic execution scenarios

Every scenario is simulated. Monetary amounts, identities, prices, resources and timestamps are test data, not invoices, approvals or observed infrastructure. These histories are deliberately separate from the fresh consumer reference.

Run the source-only verifier with an explicit consumer root and scenario root. `expected.json` and `report.md` are checked-in oracles. The verifier does not write them or execute a provider. Changing a fixture requires reviewing its worked arithmetic rather than accepting newly generated output blindly.

The oracle examples use 1 USD = 1,000,000 microcurrency units. All ancestor accounts have the same illustrative caps. A settled reservation of 20,000 with observed usage of 12,000 contributes 12,000 consumed and zero reserved, not 32,000 consumed. A timeout retains 20,000 reserved. Protected verification leaves 80,000 of its original 100,000 allowance after 20,000 has been consumed; a subsequent 80,000 protected request must not count that allocation twice.

The resumed example deliberately includes a different earlier cycle charged to the same parent account. Replacing a graph thread does not remove that 12,000 consumption or the current 20,000 uncertain liability. The overage example records 1,050,000 even though only 10,000 was reserved and the cap is 1,000,000; no value is truncated to make the scenario appear compliant.
