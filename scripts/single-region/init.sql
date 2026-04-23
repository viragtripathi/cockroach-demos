
-- Insert region location
UPSERT INTO system.locations ("localityKey", "localityValue", latitude, longitude) VALUES
  ('region', 'us-east-1', 37.7749, -77.0369);

-- Enable buffered writes
SET CLUSTER SETTING kv.transaction.write_buffering.enabled = true;

-- Verify cluster regions
SHOW REGIONS FROM CLUSTER;
