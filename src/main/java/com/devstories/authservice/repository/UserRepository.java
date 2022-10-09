package com.devstories.authservice.repository;

import com.devstories.authservice.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface UserRepository extends CrudRepository<User, String> {

    Optional<User> getUserById(String username);

    boolean existsById(String username);
}
