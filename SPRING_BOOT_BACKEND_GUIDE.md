# Spring Boot Backend Guide for GoRide

## Why Spring Boot for GoRide?

### Advantages:
✅ **Enterprise-Grade**: Battle-tested, production-ready
✅ **Type Safety**: Java's strong typing prevents runtime errors
✅ **Rich Ecosystem**: Massive library support
✅ **Security**: Spring Security for robust authentication
✅ **Scalability**: Excellent for microservices architecture
✅ **Performance**: JVM optimization, high throughput
✅ **Long-term Support**: Enterprise support available
✅ **Team Familiarity**: Many developers know Java/Spring

### Considerations:
⚠️ **Learning Curve**: Steeper than Node.js if team is new to Java
⚠️ **Development Speed**: Slightly slower initial setup
⚠️ **Memory Usage**: Higher than Node.js (but better performance)

---

## 🏗️ **Recommended Spring Boot Architecture**

### Architecture Overview:
```
┌─────────────────────────────────────┐
│      Flutter Mobile App             │
└──────────────┬──────────────────────┘
               │
               │ REST API / WebSocket
               │
    ┌──────────▼──────────┐
    │   API Gateway       │
    │  (Spring Cloud)     │
    └──────────┬──────────┘
               │
    ┌──────────┴──────────┐
    │                      │
┌───▼────┐          ┌─────▼────┐
│ Auth   │          │  Ride    │
│Service │          │ Service  │
├────────┤          ├──────────┤
│ OTP    │          │ Matching │
│ Social │          │ Tracking │
│ JWT    │          │ Pricing  │
└───┬────┘          └─────┬────┘
    │                     │
┌───▼────┐          ┌────▼────┐
│Payment │          │Location  │
│Service │          │ Service  │
├────────┤          ├──────────┤
│ Stripe │          │ Maps API │
│ PayPal │          │ Geocode  │
│ Wallet │          │ Routes   │
└───┬────┘          └────┬─────┘
    │                    │
    └──────────┬─────────┘
               │
        ┌──────▼──────┐
        │ PostgreSQL  │
        │   (Main DB) │
        └─────────────┘
               │
        ┌──────▼──────┐
        │   Redis    │
        │  (Cache)   │
        └─────────────┘
```

---

## 🛠️ **Complete Tech Stack**

### Core Framework:
- **Spring Boot 3.2+** (Java 17+)
- **Spring Security** (Authentication & Authorization)
- **Spring Data JPA** (Database ORM)
- **Spring Web** (REST APIs)
- **Spring WebSocket** (Real-time updates)

### Database:
- **PostgreSQL** (Primary database)
- **Redis** (Caching, sessions, real-time data)

### Authentication:
- **JWT** (JSON Web Tokens)
- **Spring Security OAuth2** (Social login)
- **Twilio** (Phone OTP)

### Payment Processing:
- **Stripe Java SDK**
- **PayPal SDK**
- **Spring Boot Actuator** (Monitoring)

### Location Services:
- **Google Maps Java Client**
- **Spring Boot WebClient** (HTTP client)

### Real-time:
- **WebSocket** (Spring WebSocket)
- **STOMP** (Messaging protocol)

### Additional:
- **Lombok** (Reduce boilerplate)
- **MapStruct** (Object mapping)
- **Spring Boot Validation**
- **Spring Boot Mail** (Email notifications)
- **Firebase Admin SDK** (Optional - for push notifications)

---

## 📁 **Project Structure**

```
goride-backend/
├── pom.xml (or build.gradle)
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── goride/
│       │           ├── GorideApplication.java
│       │           │
│       │           ├── config/
│       │           │   ├── SecurityConfig.java
│       │           │   ├── WebSocketConfig.java
│       │           │   ├── RedisConfig.java
│       │           │   └── CorsConfig.java
│       │           │
│       │           ├── controller/
│       │           │   ├── AuthController.java
│       │           │   ├── UserController.java
│       │           │   ├── RideController.java
│       │           │   ├── PaymentController.java
│       │           │   └── AddressController.java
│       │           │
│       │           ├── service/
│       │           │   ├── AuthService.java
│       │           │   ├── OtpService.java
│       │           │   ├── UserService.java
│       │           │   ├── RideService.java
│       │           │   ├── PaymentService.java
│       │           │   ├── LocationService.java
│       │           │   └── NotificationService.java
│       │           │
│       │           ├── repository/
│       │           │   ├── UserRepository.java
│       │           │   ├── RideRepository.java
│       │           │   ├── PaymentRepository.java
│       │           │   └── AddressRepository.java
│       │           │
│       │           ├── model/
│       │           │   ├── entity/
│       │           │   │   ├── User.java
│       │           │   │   ├── Ride.java
│       │           │   │   ├── Payment.java
│       │           │   │   └── Address.java
│       │           │   │
│       │           │   ├── dto/
│       │           │   │   ├── AuthRequest.java
│       │           │   │   ├── AuthResponse.java
│       │           │   │   └── ...
│       │           │   │
│       │           │   └── enums/
│       │           │       ├── RideStatus.java
│       │           │       └── PaymentStatus.java
│       │           │
│       │           ├── security/
│       │           │   ├── JwtTokenProvider.java
│       │           │   ├── JwtAuthenticationFilter.java
│       │           │   └── UserDetailsServiceImpl.java
│       │           │
│       │           └── exception/
│       │               ├── GlobalExceptionHandler.java
│       │               └── CustomException.java
│       │
│       └── resources/
│           ├── application.yml
│           ├── application-dev.yml
│           ├── application-prod.yml
│           └── db/
│               └── migration/
│                   └── V1__initial_schema.sql
```

---

## 🚀 **Quick Start Guide**

### 1. Initialize Spring Boot Project

#### Option A: Spring Initializr (Recommended)
Visit: https://start.spring.io/

**Dependencies to select:**
- Spring Web
- Spring Data JPA
- Spring Security
- PostgreSQL Driver
- Redis (Lettuce)
- Validation
- Lombok
- Spring Boot DevTools

#### Option B: Command Line
```bash
# Using Spring CLI
spring init --dependencies=web,data-jpa,security,postgresql,redis,validation,lombok \
  --build=gradle \
  --java-version=17 \
  --group-id=com.goride \
  --artifact-id=goride-backend \
  goride-backend
```

### 2. Project Setup

#### build.gradle (Gradle) or pom.xml (Maven)

**Gradle (build.gradle.kts):**
```kotlin
plugins {
    java
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
}

group = "com.goride"
version = "1.0.0"

java {
    sourceCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot Starters
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-websocket")
    implementation("org.springframework.boot:spring-boot-starter-data-redis")
    implementation("org.springframework.boot:spring-boot-starter-mail")
    
    // Database
    runtimeOnly("org.postgresql:postgresql")
    
    // JWT
    implementation("io.jsonwebtoken:jjwt-api:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.3")
    
    // OTP & SMS
    implementation("com.twilio.sdk:twilio:9.2.3")
    
    // Payment
    implementation("com.stripe:stripe-java:24.16.0")
    
    // Maps
    implementation("com.google.maps:google-maps-services:2.2.0")
    
    // Utilities
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    
    // MapStruct
    implementation("org.mapstruct:mapstruct:1.5.5.Final")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.5.5.Final")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
}
```

**Maven (pom.xml):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    
    <groupId>com.goride</groupId>
    <artifactId>goride-backend</artifactId>
    <version>1.0.0</version>
    
    <properties>
        <java.version>17</java.version>
        <mapstruct.version>1.5.5.Final</mapstruct.version>
    </properties>
    
    <dependencies>
        <!-- Spring Boot Starters -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-websocket</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        
        <!-- Database -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
        
        <!-- JWT -->
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>0.12.3</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>0.12.3</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>0.12.3</version>
            <scope>runtime</scope>
        </dependency>
        
        <!-- Twilio (OTP) -->
        <dependency>
            <groupId>com.twilio.sdk</groupId>
            <artifactId>twilio</artifactId>
            <version>9.2.3</version>
        </dependency>
        
        <!-- Stripe -->
        <dependency>
            <groupId>com.stripe</groupId>
            <artifactId>stripe-java</artifactId>
            <version>24.16.0</version>
        </dependency>
        
        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        
        <!-- MapStruct -->
        <dependency>
            <groupId>org.mapstruct</groupId>
            <artifactId>mapstruct</artifactId>
            <version>${mapstruct.version}</version>
        </dependency>
    </dependencies>
</project>
```

### 3. Application Configuration

**application.yml:**
```yaml
spring:
  application:
    name: goride-backend
  
  datasource:
    url: jdbc:postgresql://localhost:5432/goride_db
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
  
  redis:
    host: ${REDIS_HOST:localhost}
    port: ${REDIS_PORT:6379}
    password: ${REDIS_PASSWORD:}
  
  mail:
    host: smtp.gmail.com
    port: 587
    username: ${MAIL_USERNAME:}
    password: ${MAIL_PASSWORD:}
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true

# JWT Configuration
jwt:
  secret: ${JWT_SECRET:your-secret-key-change-in-production}
  expiration: 86400000 # 24 hours

# Twilio Configuration
twilio:
  account-sid: ${TWILIO_ACCOUNT_SID:}
  auth-token: ${TWILIO_AUTH_TOKEN:}
  phone-number: ${TWILIO_PHONE_NUMBER:}

# Stripe Configuration
stripe:
  api-key: ${STRIPE_API_KEY:}
  webhook-secret: ${STRIPE_WEBHOOK_SECRET:}

# Google Maps Configuration
google:
  maps:
    api-key: ${GOOGLE_MAPS_API_KEY:}

# Server Configuration
server:
  port: 8080
  error:
    include-message: always
    include-binding-errors: always

# Logging
logging:
  level:
    com.goride: DEBUG
    org.springframework.security: DEBUG
```

---

## 💻 **Core Implementation Examples**

### 1. User Entity

**User.java:**
```java
package com.goride.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "users")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String phoneNumber;
    
    @Column(unique = true)
    private String email;
    
    private String fullName;
    
    @Enumerated(EnumType.STRING)
    private Gender gender;
    
    private LocalDate dateOfBirth;
    
    private String profileImageUrl;
    
    @Column(nullable = false)
    private String password; // Encrypted
    
    @Enumerated(EnumType.STRING)
    private AuthProvider authProvider; // PHONE, GOOGLE, APPLE, FACEBOOK, X
    
    private String providerId; // For social login
    
    private boolean emailVerified;
    private boolean phoneVerified;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Address> addresses;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Ride> rides;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    private LocalDateTime updatedAt;
    
    public enum Gender {
        MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY
    }
    
    public enum AuthProvider {
        PHONE, GOOGLE, APPLE, FACEBOOK, X
    }
}
```

### 2. Authentication Controller

**AuthController.java:**
```java
package com.goride.controller;

import com.goride.dto.request.PhoneOtpRequest;
import com.goride.dto.request.VerifyOtpRequest;
import com.goride.dto.request.SocialLoginRequest;
import com.goride.dto.response.AuthResponse;
import com.goride.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;
    
    @PostMapping("/send-otp")
    public ResponseEntity<?> sendOtp(@Valid @RequestBody PhoneOtpRequest request) {
        authService.sendOtp(request.getPhoneNumber(), request.getCountryCode());
        return ResponseEntity.ok().body(
            Map.of("message", "OTP sent successfully")
        );
    }
    
    @PostMapping("/verify-otp")
    public ResponseEntity<AuthResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        AuthResponse response = authService.verifyOtp(
            request.getPhoneNumber(),
            request.getCountryCode(),
            request.getOtp()
        );
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/social-login")
    public ResponseEntity<AuthResponse> socialLogin(@Valid @RequestBody SocialLoginRequest request) {
        AuthResponse response = authService.socialLogin(request);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/refresh-token")
    public ResponseEntity<AuthResponse> refreshToken(@RequestHeader("Authorization") String token) {
        String jwt = token.substring(7); // Remove "Bearer "
        AuthResponse response = authService.refreshToken(jwt);
        return ResponseEntity.ok(response);
    }
}
```

### 3. OTP Service

**OtpService.java:**
```java
package com.goride.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class OtpService {
    
    private final RedisTemplate<String, String> redisTemplate;
    
    @Value("${twilio.account-sid}")
    private String accountSid;
    
    @Value("${twilio.auth-token}")
    private String authToken;
    
    @Value("${twilio.phone-number}")
    private String twilioPhoneNumber;
    
    public void sendOtp(String phoneNumber, String countryCode) {
        // Generate 4-digit OTP
        String otp = generateOtp();
        
        // Store in Redis with 5-minute expiration
        String key = "otp:" + countryCode + phoneNumber;
        redisTemplate.opsForValue().set(key, otp, 5, TimeUnit.MINUTES);
        
        // Send SMS via Twilio
        try {
            Twilio.init(accountSid, authToken);
            Message message = Message.creator(
                new PhoneNumber(countryCode + phoneNumber),
                new PhoneNumber(twilioPhoneNumber),
                "Your GoRide OTP is: " + otp
            ).create();
            
            log.info("OTP sent to {}: {}", phoneNumber, message.getSid());
        } catch (Exception e) {
            log.error("Failed to send OTP: {}", e.getMessage());
            throw new RuntimeException("Failed to send OTP", e);
        }
    }
    
    public boolean verifyOtp(String phoneNumber, String countryCode, String otp) {
        String key = "otp:" + countryCode + phoneNumber;
        String storedOtp = redisTemplate.opsForValue().get(key);
        
        if (storedOtp == null) {
            return false; // OTP expired
        }
        
        boolean isValid = storedOtp.equals(otp);
        
        if (isValid) {
            // Delete OTP after successful verification
            redisTemplate.delete(key);
        }
        
        return isValid;
    }
    
    private String generateOtp() {
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000); // 4-digit OTP
        return String.valueOf(otp);
    }
}
```

### 4. JWT Token Provider

**JwtTokenProvider.java:**
```java
package com.goride.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
@Slf4j
public class JwtTokenProvider {
    
    @Value("${jwt.secret}")
    private String jwtSecret;
    
    @Value("${jwt.expiration}")
    private long jwtExpiration;
    
    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }
    
    public String generateToken(Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);
        
        return Jwts.builder()
            .subject(userDetails.getUsername())
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(getSigningKey())
            .compact();
    }
    
    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parser()
            .verifyWith(getSigningKey())
            .build()
            .parseSignedClaims(token)
            .getPayload();
        
        return claims.getSubject();
    }
    
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            log.error("Invalid JWT token: {}", e.getMessage());
            return false;
        }
    }
}
```

### 5. Payment Service

**PaymentService.java:**
```java
package com.goride.service;

import com.goride.model.entity.Payment;
import com.goride.model.entity.User;
import com.goride.model.enums.PaymentMethod;
import com.goride.model.enums.PaymentStatus;
import com.goride.repository.PaymentRepository;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentService {
    
    private final PaymentRepository paymentRepository;
    
    @Value("${stripe.api-key}")
    private String stripeApiKey;
    
    @Transactional
    public Payment processTopUp(User user, BigDecimal amount, PaymentMethod method, String paymentMethodId) {
        Stripe.apiKey = stripeApiKey;
        
        try {
            // Create Stripe Payment Intent
            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                .setAmount(amount.multiply(BigDecimal.valueOf(100)).longValue()) // Convert to cents
                .setCurrency("usd")
                .setPaymentMethod(paymentMethodId)
                .setConfirm(true)
                .setReturnUrl("goride://payment-success")
                .build();
            
            PaymentIntent paymentIntent = PaymentIntent.create(params);
            
            // Save payment record
            Payment payment = Payment.builder()
                .user(user)
                .amount(amount)
                .paymentMethod(method)
                .status(PaymentStatus.COMPLETED)
                .transactionId(paymentIntent.getId())
                .stripePaymentIntentId(paymentIntent.getId())
                .createdAt(LocalDateTime.now())
                .build();
            
            // Update user wallet balance
            user.setWalletBalance(user.getWalletBalance().add(amount));
            
            return paymentRepository.save(payment);
            
        } catch (StripeException e) {
            log.error("Stripe payment failed: {}", e.getMessage());
            throw new RuntimeException("Payment processing failed", e);
        }
    }
    
    public Payment getPaymentByTransactionId(String transactionId) {
        return paymentRepository.findByTransactionId(transactionId)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
    }
}
```

### 6. Security Configuration

**SecurityConfig.java:**
```java
package com.goride.config;

import com.goride.security.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    
    private final JwtAuthenticationFilter jwtAuthFilter;
    private final UserDetailsService userDetailsService;
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .authenticationProvider(authenticationProvider())
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
    
    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }
    
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:3000", "http://localhost:8080"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

---

## 🔌 **Flutter Integration**

### HTTP Client Setup in Flutter:

**api_client.dart:**
```dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'http://your-spring-boot-server:8080/api';
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors
        return handler.next(error);
      },
    ));
  }
  
  Future<Response> sendOtp(String phoneNumber, String countryCode) async {
    return await _dio.post('/auth/send-otp', data: {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
    });
  }
  
  Future<Response> verifyOtp(String phoneNumber, String countryCode, String otp) async {
    return await _dio.post('/auth/verify-otp', data: {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'otp': otp,
    });
  }
}
```

---

## 🚀 **Deployment Options**

### 1. Docker Deployment

**Dockerfile:**
```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY build/libs/goride-backend-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - DB_HOST=postgres
      - REDIS_HOST=redis
    depends_on:
      - postgres
      - redis
  
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: goride_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

### 2. Cloud Deployment

**AWS:**
- EC2 (EC2 instance)
- ECS (Container service)
- Elastic Beanstalk (PaaS)

**Google Cloud:**
- Cloud Run (Serverless containers)
- App Engine (PaaS)
- GKE (Kubernetes)

**Azure:**
- App Service (PaaS)
- Container Instances
- AKS (Kubernetes)

---

## 📊 **Performance Optimization**

### 1. Database Optimization:
- Use connection pooling
- Implement database indexes
- Use JPA query optimization
- Enable second-level cache (Hibernate)

### 2. Caching:
- Redis for frequently accessed data
- Spring Cache abstraction
- Cache user sessions
- Cache location data

### 3. API Optimization:
- Pagination for lists
- Response compression
- Async processing for heavy operations
- Connection pooling

---

## ✅ **Advantages of Spring Boot for GoRide**

1. ✅ **Enterprise-Ready**: Production-grade framework
2. ✅ **Type Safety**: Java prevents many runtime errors
3. ✅ **Security**: Spring Security is industry-standard
4. ✅ **Scalability**: Excellent for microservices
5. ✅ **Ecosystem**: Huge library ecosystem
6. ✅ **Performance**: JVM optimization
7. ✅ **Long-term Support**: Enterprise support available
8. ✅ **Team Skills**: Many developers know Java/Spring

---

## 🎯 **Next Steps**

1. ✅ Set up Spring Boot project
2. ✅ Configure database (PostgreSQL)
3. ✅ Implement authentication (OTP, JWT)
4. ✅ Create REST APIs
5. ✅ Integrate payment processing
6. ✅ Add real-time features (WebSocket)
7. ✅ Deploy to production

Would you like me to:
1. Create the complete project structure?
2. Implement specific endpoints?
3. Set up database schema?
4. Configure deployment?

