package org.quickcart.authserver.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.server.authorization.client.*;
import org.springframework.security.oauth2.server.authorization.settings.AuthorizationServerSettings;

import java.util.UUID;

@Configuration
public class AuthorizationServerConfig {

    @Value("${app.issuer}")
    private String issuer;


    @Bean
    public RegisteredClientRepository registeredClientRepository(
            PasswordEncoder passwordEncoder) {

        RegisteredClient quickcartClient =
                RegisteredClient.withId(UUID.randomUUID().toString())
                        .clientId("quickcart-client")
                        .clientSecret(passwordEncoder.encode("quickcart-secret"))
                        .authorizationGrantType(AuthorizationGrantType.CLIENT_CREDENTIALS)
                        .scope("read")
                        .scope("write")
                        .build();

        return new InMemoryRegisteredClientRepository(quickcartClient);
    }

    @Bean
    public AuthorizationServerSettings authorizationServerSettings() {
        return AuthorizationServerSettings.builder()
                .issuer(issuer)
                .build();
    }
}
