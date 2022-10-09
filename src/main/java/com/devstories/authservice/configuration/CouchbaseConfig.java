package com.devstories.authservice.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.couchbase.config.AbstractCouchbaseConfiguration;

@Configuration
public class CouchbaseConfig extends AbstractCouchbaseConfiguration {

    @Override
    public String getConnectionString() {
        return "couchbase://127.0.0.1";
    }

    @Override
    public String getUserName() {
        return "laser";
    }

    @Override
    public String getPassword() {
        return "laser123";
    }

    @Override
    public String getBucketName() {
        return "dev-stories";
    }
}
