# Salesforce Developer Core – Portfolio

Repositório público com entregas práticas do programa **Salesforce Developer Core (OSF Academy – 6 semanas)** + estudos no Trailhead.

## Destaques (Hands-on)

- **Apex Triggers + Tests**: validação de CEP (BR/RO) em Account (handler/service + testes)
- **Apex Trigger + Tests**: atribuição de desconto por Stage em Opportunity
- **Callout + Mock + Tests**: serviço Apex consumindo API externa (WeatherService) com mock e testes
- **LWC + Jest**: componente `accountWeather` com testes unitários
- **Batch + Schedulable**: arquivamento de Contacts (campo custom `Is_Archived__c`)

## Estrutura

- `force-app/main/default/classes`
- `force-app/main/default/triggers`
- `force-app/main/default/lwc`
- `force-app/main/default/objects`

## Para deploy e tests (exemplos):

- `sf org login web -o <alias>`
- `sf project deploy start --source-dir force-app --target-org <alias>`
- `sf apex run test --test-level RunLocalTests --target-org <alias>`
- `npm ci`
- ` npm run test:unit`

## Links

- Meu LinkedIn: https://www.linkedin.com/in/igoquaresma/
