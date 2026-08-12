-- The envelope namespace is no longer control-plane input: the operator derives
-- it from the install prefix and the CR name and publishes it on status.namespace.
-- What the control plane still owns is the CR NAME, which is what these columns
-- have really held — rename them to say so.
--
-- v1alpha1 has no production consumers and cluster execution is off by default.
-- A row written before this migration still carries the old, prefix-INCLUDING
-- value, and the name is only ever written on insert: an install that did enable
-- cluster execution should disable it (which tears the old envelope down under
-- the stored name) and drop the row before enabling again.

-- AlterTable
ALTER TABLE "org_cluster_execution" RENAME COLUMN "targetNamespace" TO "resourceName";

-- AlterIndex
ALTER INDEX "org_cluster_execution_targetNamespace_key" RENAME TO "org_cluster_execution_resourceName_key";

-- AlterTable
ALTER TABLE "pending_envelope_teardown" RENAME COLUMN "targetNamespace" TO "resourceName";
