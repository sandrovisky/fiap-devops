# App Busca CEP - Clean Architecture

> Projeto desenvolvido para o MBA em Cloud Architecture - FIAP

Aplicativo Flutter para busca de endereços por CEP utilizando a API ViaCEP, desenvolvido seguindo os princípios de Clean Architecture com pipeline completo de CI/CD.

## 🎯 Objetivo do Projeto

Este projeto foi desenvolvido como parte do trabalho de conclusão do MBA em Cloud Architecture, com o objetivo de demonstrar a implementação de uma **esteira de CI/CD completa** utilizando GitHub Actions, aplicando conceitos de DevOps, automação e boas práticas de desenvolvimento.

## 🚀 Demo ao Vivo

**Acesse a aplicação:** [https://sandrovisky.github.io/fiap-devops/](https://sandrovisky.github.io/fiap-devops/)

## 🔄 Pipeline CI/CD (GitHub Actions)

A esteira automatizada implementada cobre os seguintes processos:

### ✅ Testes e Qualidade de Código
- **Análise Estática**: Verificação automática de código com `flutter analyze`
- **Formatação**: Padronização de código com `dart format`
- **Testes Unitários**: Execução de 23 testes cobrindo todas as camadas
- **Cobertura de Código**: Geração e upload para Codecov

### 🏗️ Build
- **Build Web**: Compilação otimizada para produção
- **Geração de Artefatos**: Build disponibilizado para download por 7 dias

### 🌐 Deploy Automático
- **GitHub Pages**: Deploy automático na branch `main`
- **URL Base Configurada**: Aplicação acessível publicamente
- **Deploy Condicional**: Apenas em push para `main`

### 📋 Gatilhos da Pipeline
```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
```

### 🔐 Segurança e Permissões
- Utilização de `GITHUB_TOKEN` com permissões controladas
- Isolamento de ambientes de build
- Cache de dependências para otimização

## 📐 Arquitetura

O projeto está organizado em três camadas principais, seguindo os princípios de Clean Architecture:

### 🔵 Domain Layer (Camada de Domínio)
Contém a lógica de negócio pura, independente de frameworks e bibliotecas externas.

```
lib/features/address/domain/
├── entities/           # Entidades de domínio
│   └── address.dart
├── repositories/       # Interfaces dos repositórios
│   └── address_repository.dart
└── usecases/          # Casos de uso
    └── get_address_by_cep.dart
```

### 🟢 Data Layer (Camada de Dados)
Implementa os repositórios e gerencia as fontes de dados.

```
lib/features/address/data/
├── datasources/       # Fontes de dados (API)
│   └── address_remote_data_source.dart
├── models/            # Models com conversão JSON
│   └── address_model.dart
└── repositories/      # Implementação dos repositórios
    └── address_repository_impl.dart
```

### 🟡 Presentation Layer (Camada de Apresentação)
Gerencia a interface do usuário e o estado da aplicação.

```
lib/features/address/presentation/
├── bloc/              # Gerenciamento de estado com BLoC
│   ├── address_bloc.dart
│   ├── address_event.dart
│   └── address_state.dart
├── pages/             # Telas do aplicativo
│   └── address_page.dart
└── widgets/           # Widgets reutilizáveis
    ├── address_display.dart
    └── address_form.dart
```

### 🛠️ Core
Funcionalidades compartilhadas entre features.

```
lib/core/
├── error/             # Tratamento de erros
│   └── failures.dart
└── usecases/          # Base para casos de uso
    └── usecase.dart
```

## 🔧 Dependências

### Principais
- **flutter_bloc**: Gerenciamento de estado
- **dartz**: Programação funcional (Either)
- **equatable**: Comparação de objetos
- **http**: Cliente HTTP para requisições
- **get_it**: Injeção de dependências

### Testes
- **mockito**: Criação de mocks
- **bloc_test**: Testes para BLoC
- **build_runner**: Geração de código
- **integration_test**: Testes de integração

## 🧪 Testes

O projeto possui cobertura completa de testes:

### Testes Unitários

1. **Domain Layer**
   - `test/features/address/domain/usecases/get_address_by_cep_test.dart`

2. **Data Layer**
   - `test/features/address/data/models/address_model_test.dart`
   - `test/features/address/data/datasources/address_remote_data_source_test.dart`
   - `test/features/address/data/repositories/address_repository_impl_test.dart`

3. **Presentation Layer**
   - `test/features/address/presentation/bloc/address_bloc_test.dart`

### Testes de Integração
- `integration_test/app_test.dart`

## 🚀 Como Executar

### Instalar dependências
```bash
cd app
flutter pub get
```

### Gerar mocks para testes
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Executar o aplicativo
```bash
flutter run
```

### Executar testes unitários
```bash
flutter test
```

### Executar testes de integração
```bash
flutter test integration_test/app_test.dart
```

### Executar todos os testes com cobertura
```bash
flutter test --coverage
```

## 📱 Funcionalidades

- ✅ Busca de endereço por CEP
- ✅ Validação de formato do CEP
- ✅ Formatação automática do CEP (XXXXX-XXX)
- ✅ Tratamento de erros (CEP inválido, não encontrado, sem conexão)
- ✅ Interface responsiva e intuitiva
- ✅ Feedback visual durante o carregamento

## 🎯 Princípios Aplicados

- **SOLID**: Cada classe tem uma única responsabilidade
- **Dependency Inversion**: Dependências são injetadas através de interfaces
- **Testabilidade**: Todas as camadas possuem interfaces testáveis
- **Separation of Concerns**: Cada camada tem sua responsabilidade bem definida
- **Clean Code**: Código limpo, legível e manutenível

## 🧩 Injeção de Dependências

A configuração de injeção de dependências está em `lib/injection_container.dart`, utilizando o GetIt:

```dart
// BLoC
getIt.registerFactory(() => AddressBloc(getAddressByCep: getIt()));

// Use Cases
getIt.registerLazySingleton(() => GetAddressByCep(getIt()));

// Repositories
getIt.registerLazySingleton<AddressRepository>(
  () => AddressRepositoryImpl(remoteDataSource: getIt()),
);

// Data Sources
getIt.registerLazySingleton<AddressRemoteDataSource>(
  () => AddressRemoteDataSourceImpl(httpClient: getIt()),
);

// External
getIt.registerLazySingleton(() => http.Client());
```

## 📊 Fluxo de Dados

```
User Input (CEP)
    ↓
AddressBloc (AddressEvent)
    ↓
GetAddressByCep (Use Case)
    ↓
AddressRepository (Interface)
    ↓
AddressRepositoryImpl
    ↓
AddressRemoteDataSource (Interface)
    ↓
AddressRemoteDataSourceImpl
```

## 🏗️ Estrutura do Repositório

```
fiap-devops/
├── .github/
│   └── workflows/
│       └── flutter-ci.yml    # Pipeline CI/CD
│
└── app/                       # Aplicação Flutter
    ├── lib/
    │   ├── core/
    │   ├── features/
    │   ├── injection_container.dart
    │   └── main.dart
    ├── test/
    ├── integration_test/
    └── pubspec.yaml
```

## 🔧 Tecnologias e Ferramentas

### Framework e Linguagem
- **Flutter 3.27.1**: Framework multiplataforma
- **Dart 3.x**: Linguagem de programação

### Arquitetura e Padrões
- **Clean Architecture**: Separação em camadas (Domain, Data, Presentation)
- **BLoC Pattern**: Gerenciamento de estado reativo
- **Dependency Injection**: GetIt para inversão de dependências
- **Repository Pattern**: Abstração de fontes de dados

### CI/CD e DevOps
- **GitHub Actions**: Automação da pipeline
- **GitHub Pages**: Hospedagem estática
- **Codecov**: Análise de cobertura de código

### Testes
- **23 Testes Unitários**: Cobertura completa das camadas
- **Mockito**: Framework de mocking
- **BLoC Test**: Testes específicos para BLoC
- **Integration Test**: Testes E2E

## 📊 Fluxo da Esteira CI/CD

```
Push/PR → GitHub Actions
    ↓
[Job: Test]
    ├─ Checkout código
    ├─ Setup Flutter 3.27.1
    ├─ Instalar dependências
    ├─ Formatar código
    ├─ Análise estática
    ├─ Executar 23 testes
    └─ Upload cobertura
    ↓
[Job: Build Web] (se testes passarem)
    ├─ Checkout código
    ├─ Setup Flutter
    ├─ Build Web Release
    ├─ Salvar artefato (7 dias)
    └─ Deploy GitHub Pages (só main)
    ↓
✅ App disponível em:
https://sandrovisky.github.io/fiap-devops/
```

## 🤝 Sobre o Projeto Acadêmico

Este projeto foi desenvolvido como exemplo prático de:
- Implementação de pipeline CI/CD completa
- Aplicação de princípios de Clean Architecture
- Automação de testes e deploy
- Boas práticas de DevOps e Cloud Computing
- Integração contínua e entrega contínua

**Instituição**: FIAP  
**Curso**: MBA em Cloud Architecture  
**Foco**: DevOps, CI/CD e Arquitetura de Software
O aplicativo trata diversos cenários de erro:

- **CEP Inválido**: Validação de formato (8 dígitos)
- **CEP Não Encontrado**: Mensagem quando a API não encontra o CEP
- **Erro de Conexão**: Mensagem quando não há internet
- **Erro de Servidor**: Mensagem para erros da API

## 🏗️ Estrutura de Pastas Completa

```
app/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   └── usecases/
│   ├── features/
│   │   └── address/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── injection_container.dart
│   └── main.dart
├── test/
│   └── features/
│       └── address/
│           ├── data/
│           ├── domain/
│           └── presentation/
├── integration_test/
│   └── app_test.dart
└── pubspec.yaml
```

## 🤝 Contribuindo

Este projeto foi desenvolvido como exemplo de Clean Architecture em Flutter, seguindo as melhores práticas de desenvolvimento mobile.

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
