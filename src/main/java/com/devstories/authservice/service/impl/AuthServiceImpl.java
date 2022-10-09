package com.devstories.authservice.service.impl;

import com.devstories.authservice.dto.JwtResponse;
import com.devstories.authservice.dto.LoginRequest;
import com.devstories.authservice.dto.RegisterRequest;
import com.devstories.authservice.dto.UserDto;
import com.devstories.authservice.model.User;
import com.devstories.authservice.repository.UserRepository;
import com.devstories.authservice.security.JwtUtils;
import com.devstories.authservice.security.MyUserDetails;
import com.devstories.authservice.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final PasswordEncoder encoder;
    private final JwtUtils jwtUtils;

    @Override
    public JwtResponse login(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        MyUserDetails userDetails = (MyUserDetails) authentication.getPrincipal();
        return new JwtResponse(jwt, userDetails.getId(), userDetails.getUsername());
    }

    @Override
    public UserDto register(RegisterRequest registerRequest) {
        if (Boolean.TRUE.equals(userRepository.existsById(registerRequest.getUsername()))) {
            throw new RuntimeException("already exists");
        }
        User user = User.builder()
                .username(registerRequest.getUsername())
                .password(encoder.encode(registerRequest.getPassword()))
                .build();
        user = userRepository.save(user);
        return UserDto.of(user);
    }
}
