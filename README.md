# tfg-proyecto
Repositorio para dar acceso al proyecto desarrollado para mi tfg, Sistema basado en VHDL para la generación y análisis de paquetes de datos en una red Ethernet Gigabit bajo condiciones de tráfico intenso.

## Cómo generar el proyecto de vivado.
Acceder al directorio gateware con:
```cd gateware```

Ejecutar el script de bash:
```./main.sh```

Importante, es necesario tener instalada la version de vivado 2022.3 Enterprise, si no, no se podrá generar el proyecto.

## Instalación del docker para construir la imagen de petalinux

Copiar el archivo de instalador 'petalinux_docker/petalinux-v2022.2-10141622-installer.run' en el directorio petalinux_docker

```cd petalinux_docker```

```make```

## Contruir el proyecto de petalinux

Acceder al directorio software
```cd software```

Ejecutar Makefile:
```make project```