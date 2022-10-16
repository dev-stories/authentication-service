package com.devstories.authservice.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.couchbase.config.AbstractCouchbaseConfiguration;

@Configuration
public class CouchbaseConfig extends AbstractCouchbaseConfiguration {

    @Override
    public String getConnectionString() {
        return "couchbase";
    }

    @Override
    public String getUserName() {
        return "cagillaser";
    }

    @Override
    public String getPassword() {
        return "cagillaser123";
    }

    @Override
    public String getBucketName() {
        return "dev-stories";
    }
}