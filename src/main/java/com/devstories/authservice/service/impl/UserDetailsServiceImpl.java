package com.devstories.authservice.service.impl;

import com.devstories.authservice.model.User;
import com.devstories.authservice.repository.UserRepository;
import com.devstories.authservice.security.MyUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.getUserById(username)
                .orElseThrow(() -> new UsernameNotFoundException("Username not found in the system: " + username));
        return MyUserDetails.build(user);
    }
}
