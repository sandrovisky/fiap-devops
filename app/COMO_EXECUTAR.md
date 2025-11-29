# Guia de Execução - App Busca CEP

## 📋 Pré-requisitos

- Flutter SDK instalado (recomendado: versão 3.9 ou superior)
- Dart SDK (incluído com Flutter)
- Editor de código (VS Code, Android Studio, etc.)
- Emulador Android/iOS ou dispositivo físico conectado

## 🚀 Passos para Executar

### 1. Navegue até o diretório do projeto
```bash
cd app
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Verifique se há dispositivos disponíveis
```bash
flutter devices
```

### 4. Execute o aplicativo
```bash
flutter run
```

## 🧪 Executando Testes

### Testes Unitários
Execute todos os testes unitários:
```bash
flutter test
```

Execute um teste específico:
```bash
flutter test test/features/address/domain/usecases/get_address_by_cep_test.dart
```

### Testes com Cobertura
```bash
flutter test --coverage
```

Para visualizar a cobertura (requer lcov):
```bash
genhtml coverage/lcov.info -o coverage/html
```

### Testes de Integração
```bash
flutter test integration_test/app_test.dart
```

## 📱 Testando no Navegador (Web)
```bash
flutter run -d chrome
```

## 🔧 Gerando Mocks (se necessário)
Se você adicionar novos testes com Mockito, execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📊 Análise de Código
Execute a análise estática:
```bash
flutter analyze
```

## 🐛 Modo Debug
Para executar em modo debug com hot reload:
```bash
flutter run
```

Então pressione:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

## 📦 Construindo para Produção

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🎯 Testando o App

1. **CEP Válido**: Digite `01310100` ou `01310-100`
   - Deve retornar: Avenida Paulista, São Paulo/SP

2. **CEP Inválido**: Digite `123`
   - Deve mostrar erro: "CEP deve conter 8 dígitos"

3. **CEP Não Encontrado**: Digite `99999999`
   - Deve mostrar erro: "CEP não encontrado"

## 🛠️ Troubleshooting

### Erro: "Waiting for another flutter command to release the startup lock"
```bash
rm ./flutter/bin/cache/lockfile  # macOS/Linux
del .\flutter\bin\cache\lockfile  # Windows
```

### Erro de dependências
```bash
flutter clean
flutter pub get
```

### Erro no iOS (macOS)
```bash
cd ios
pod install
cd ..
flutter run
```

## 📝 Comandos Úteis

- `flutter doctor` - Verifica a instalação do Flutter
- `flutter clean` - Limpa o cache de build
- `flutter pub upgrade` - Atualiza as dependências
- `flutter pub outdated` - Lista pacotes desatualizados
- `flutter format .` - Formata o código
- `flutter build` - Lista opções de build

## 🔍 Estrutura de Testes

```
test/
└── features/
    └── address/
        ├── data/
        │   ├── datasources/      # Testes do data source
        │   ├── models/           # Testes dos models
        │   └── repositories/     # Testes do repositório
        ├── domain/
        │   └── usecases/         # Testes dos casos de uso
        └── presentation/
            └── bloc/             # Testes do BLoC

integration_test/
└── app_test.dart                 # Testes E2E
```

## 💡 Dicas

1. Use `flutter run` com hot reload para desenvolvimento rápido
2. Execute `flutter test` antes de fazer commits
3. Use `flutter analyze` para verificar problemas de código
4. Configure seu IDE para formatar automaticamente ao salvar
5. Utilize breakpoints no debugger para investigar problemas

## 🌐 Recursos Adicionais

- [Documentação Flutter](https://flutter.dev/docs)
- [API ViaCEP](https://viacep.com.br/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
