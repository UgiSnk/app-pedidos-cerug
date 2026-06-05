# -*- coding: utf-8 -*-
import os
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, ListFlowable, ListItem, Image
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_JUSTIFY

# Custom Canvas to support "Page X of Y" and clean headers/footers
class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_elements(num_pages)
            canvas.Canvas.showPage(self)
        canvas.Canvas.save(self)

    def draw_page_elements(self, page_count):
        self.saveState()
        
        # Color definitions
        gray_text = colors.HexColor("#718096")
        light_gray = colors.HexColor("#E2E8F0")
        
        # Margins & positions
        left_margin = 54
        right_margin = 612 - 54
        
        # Header (Only on page 2 and later)
        if self._pageNumber > 1:
            self.setFont("Helvetica-Bold", 8)
            self.setFillColor(colors.HexColor("#373126"))
            self.drawString(left_margin, 752, "CATÁLOGO DE PEDIDOS")
            
            self.setFont("Helvetica", 8)
            self.setFillColor(gray_text)
            self.drawRightString(right_margin, 752, "Manual de Operación de Software")
            
            # Header line
            self.setStrokeColor(light_gray)
            self.setLineWidth(0.5)
            self.line(left_margin, 744, right_margin, 744)
            
        # Footer (On all pages)
        self.setStrokeColor(light_gray)
        self.setLineWidth(0.5)
        self.line(left_margin, 54, right_margin, 54)
        
        self.setFont("Helvetica", 8)
        self.setFillColor(gray_text)
        self.drawString(left_margin, 38, "Plataforma de Pedidos Web  |  Manual de Operación")
        
        page_text = f"Página {self._pageNumber} de {page_count}"
        self.drawRightString(right_margin, 38, page_text)
        
        self.restoreState()

def build_pdf(filename):
    # Setup document geometry (letter size: 612 x 792 pt)
    # Margins: Left/Right 54pt (0.75in), Top/Bottom 72pt (1.0in)
    doc = SimpleDocTemplate(
        filename,
        pagesize=letter,
        leftMargin=54,
        rightMargin=54,
        topMargin=72,
        bottomMargin=72
    )
    
    # Custom styles
    styles = getSampleStyleSheet()
    
    # Color Palette
    primary_color = colors.HexColor("#373126")   # Carbon / Dark Brown
    accent_color = colors.HexColor("#DCC39A")    # Warm Gold
    body_color = colors.HexColor("#2D3748")      # Charcoal Gray
    
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=28,
        textColor=primary_color,
        alignment=TA_CENTER,
        spaceAfter=10
    )
    
    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        textColor=accent_color,
        alignment=TA_CENTER,
        spaceAfter=30
    )
    
    h1_style = ParagraphStyle(
        'SectionHeading',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=15,
        leading=19,
        textColor=primary_color,
        spaceBefore=18,
        spaceAfter=8,
        keepWithNext=True
    )
    
    h2_style = ParagraphStyle(
        'SubSectionHeading',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=11,
        leading=15,
        textColor=accent_color,
        spaceBefore=10,
        spaceAfter=6,
        keepWithNext=True
    )
    
    body_style = ParagraphStyle(
        'BodyTextCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=14.5,
        textColor=body_color,
        spaceAfter=8,
        alignment=TA_LEFT
    )
    
    bullet_style = ParagraphStyle(
        'BulletCustom',
        parent=body_style,
        leftIndent=15,
        firstLineIndent=-10,
        spaceAfter=4
    )
    
    code_style = ParagraphStyle(
        'CodeStyle',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor("#1A202C"),
        spaceAfter=0
    )
    
    # Helper to build callout box
    def callout_box(text, border_color=accent_color, bg_color=colors.HexColor("#FDFBF7")):
        p = Paragraph(text, ParagraphStyle('CalloutP', parent=body_style, fontSize=9, leading=13))
        t = Table([[p]], colWidths=[504])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), bg_color),
            ('PADDING', (0,0), (-1,-1), 8),
            ('LINELEFT', (0,0), (0,-1), 2.5, border_color),
            ('TOPPADDING', (0,0), (-1,-1), 6),
            ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ]))
        return t

    # Helper to build code block box
    def code_block(code_text):
        p = Paragraph(code_text.replace("\n", "<br/>").replace(" ", "&nbsp;"), code_style)
        t = Table([[p]], colWidths=[504])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F7FAFC")),
            ('BORDER', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
            ('PADDING', (0,0), (-1,-1), 8),
            ('TOPPADDING', (0,0), (-1,-1), 6),
            ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ]))
        return t

    story = []
    
    # ================= PAGE 1: COVER & INTRO =================
    story.append(Spacer(1, 100))
        
    story.append(Paragraph("MANUAL DE USUARIO Y OPERACIÓN", subtitle_style))
    story.append(Paragraph("Catálogo Móvil de Pedidos &<br/>Portal Administrador Web", title_style))
    story.append(Paragraph("Ecosistema de Levantamiento de Pedidos Integrado con WhatsApp", subtitle_style))
    story.append(Spacer(1, 20))
    
    # Decorative divider
    divider = Table([[""]], colWidths=[504], rowHeights=[2])
    divider.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), accent_color),
        ('TOPPADDING', (0,0), (-1,-1), 0),
        ('BOTTOMPADDING', (0,0), (-1,-1), 0),
    ]))
    story.append(divider)
    story.append(Spacer(1, 25))
    
    intro_p1 = (
        "Este manual describe la operación y gestión de la plataforma digital para la toma de pedidos. "
        "El ecosistema está compuesto por dos herramientas sincronizadas en tiempo real: "
        "<b>(1) La App Web Cliente</b>, optimizada para celulares, que permite a los clientes explorar el catálogo de productos "
        "y enviar pedidos con formato detallado directamente al WhatsApp de su vendedor asignado, y "
        "<b>(2) El Portal del Administrador</b>, que facilita el control del inventario, la base de datos de vendedores "
        "y la generación de enlaces de acceso."
    )
    story.append(Paragraph(intro_p1, body_style))
    story.append(Spacer(1, 15))
    
    concept_title = "<b>Concepto del Ecosistema:</b>"
    story.append(Paragraph(concept_title, body_style))
    story.append(Paragraph("• <b>Carga Única:</b> Las categorías, productos y vendedores se editan en el panel de administrador y se reflejan instantáneamente en la app de los clientes.", bullet_style))
    story.append(Paragraph("• <b>Sin Instalación:</b> Funciona directamente como un sitio web móvil (PWA), evitando que el cliente deba descargar nada de la Play Store o App Store.", bullet_style))
    story.append(Paragraph("• <b>Cero Fricción:</b> Los pedidos finalizados se transforman en mensajes de WhatsApp estructurados listos para enviar al vendedor con un toque.", bullet_style))
    
    story.append(PageBreak())
    
    # ================= PAGE 2: CLIENT APP =================
    story.append(Paragraph("1. Manual de la App Cliente (Catálogo de Pedidos)", h1_style))
    
    icon_path = r"C:\Users\Ugi Desk\.gemini\antigravity\brain\79a21994-9700-4f3a-8e40-14ad9ff8424e\manual_app_icon_1780681881327.png"
    if os.path.exists(icon_path):
        icon_tbl = Table([[Image(icon_path, width=70, height=70)]], colWidths=[504])
        icon_tbl.setStyle(TableStyle([
            ('ALIGN', (0,0), (-1,-1), 'CENTER'),
            ('BOTTOMPADDING', (0,0), (-1,-1), 10),
        ]))
        story.append(icon_tbl)
        
    story.append(Paragraph(
        "La aplicación cliente está disponible en la URL oficial de tu hosting. "
        "Aunque puede abrirse de forma general, está diseñada para ser compartida mediante <b>enlaces de vendedor personalizados</b>. "
        "Esto asegura que la compra sea atendida por el asesor correspondiente.",
        body_style
    ))
    
    story.append(Paragraph("1.1 Acceso y Reconocimiento de Vendedores", h2_style))
    story.append(Paragraph(
        "Para que la app asocie a un cliente con un vendedor específico, se utiliza el parámetro <b>?vendedorID=</b> en el enlace. "
        "Al hacer clic en este enlace, el navegador web móvil activa automáticamente la asignación de sesión:",
        body_style
    ))
    
    story.append(Paragraph("<b>Enlaces de Vendedor Activos:</b>", body_style))
    story.append(Paragraph("• <b>ID Vendedor:</b><br/>"
                           "<font face='Courier' color='#1A202C'>https://pedidos-component.web.app/?vendedorID=*ID del vendedor*</font>", bullet_style))
    
    story.append(Spacer(1, 5))
    story.append(callout_box(
        "<b>¿Cómo verificar la sesión activa?</b><br/>"
        "Al entrar al enlace, en la barra superior de color dorado figurará la leyenda "
        "<b>'Vendedor: [Nombre Vendedor]'</b> con su fotografía circular. Si el cliente ingresa al link base "
        "sin parámetros, la app se iniciará con el primer vendedor cargado en la base de datos por defecto (fallback)."
    ))
    
    story.append(Paragraph("1.2 Flujo de Compra en el Catálogo", h2_style))
    story.append(Paragraph(
        "El cliente interactúa con una interfaz premium e intuitiva:",
        body_style
    ))
    story.append(Paragraph("1. <b>Pantalla de Inicio:</b> Muestra el banner principal, la barra del vendedor asignado con el prefijo 'Vendedor:' y el panel de categorías con imágenes desaturadas sepia y doble borde blanco.", bullet_style))
    story.append(Paragraph("2. <b>Sección de Productos (Categorías):</b> Al tocar una categoría (ej. Velas), se despliega la grilla de productos correspondientes. Cada tarjeta contiene la foto del producto, su descripción, el precio y el <b>Código Interno (SKU)</b>.", bullet_style))
    story.append(Paragraph("3. <b>Contador de Cantidad:</b> El cliente agrega productos usando los botones (+) y (-). Si el producto ya está en el carrito, el ícono del basurero (🗑️) se encenderá en color rojo para permitir su remoción.", bullet_style))
    story.append(Paragraph("4. <b>Detalle del Producto:</b> Tocar la tarjeta del producto abre una vista ampliada con imágenes grandes, especificaciones técnicas detalladas (medidas, colores) y descripción de uso.", bullet_style))
    story.append(Paragraph("5. <b>Carrito de Compras:</b> Reúne el listado de ítems seleccionados, el precio unitario, la cantidad y calcula el total de la compra. Permite corregir cantidades antes del envío final.", bullet_style))
    
    story.append(Paragraph("1.3 Envío del Pedido por WhatsApp", h2_style))
    story.append(Paragraph(
        "Al presionar el botón <b>'Realizar Pedido por WhatsApp'</b> en la pantalla del carrito, la app realiza el procesamiento automático en segundo plano:",
        body_style
    ))
    story.append(Paragraph("• Redirige al cliente al chat oficial de WhatsApp del vendedor asignado usando su número en la base de datos.", bullet_style))
    story.append(Paragraph("• Genera un texto formateado que incluye el Código Interno (SKU) de cada producto, cantidades y el precio final de la orden.", bullet_style))
    
    story.append(Spacer(1, 5))
    story.append(code_block(
        "*NUEVO PEDIDO RECIBIDO*\n"
        "----------------------------------------\n"
        "Cliente: Pablo Gómez\n"
        "Vendedor Asignado: *Nombre Comercial*\n"
        "----------------------------------------\n"
        "• 2 x [VEL-GR-NE] Vela Grande Negro - $44000\n"
        "• 1 x [VAS-CH] Vaso chico con vela - $32000\n"
        "----------------------------------------\n"
        "*TOTAL DE LA COMPRA: $76000*\n"
        "----------------------------------------\n"
        "Por favor, coordinar envío y forma de pago."
    ))
    
    story.append(PageBreak())
    
    # ================= PAGE 3: ADMIN PORTAL =================
    story.append(Paragraph("2. Manual del Portal de Administración", h1_style))
    story.append(Paragraph(
        "El portal administrativo web está diseñado para computadoras y tablets, disponible en la subcarpeta "
        "<b>/admin/</b> dentro de tu hosting. Utiliza la autenticación del backend para el control de acceso.",
        body_style
    ))
    
    story.append(Paragraph("2.1 Acceso e Inicio de Sesión", h2_style))
    story.append(Paragraph(
        "Para ingresar al panel, se requiere autenticación. Las credenciales actuales del sistema son:",
        body_style
    ))
    story.append(Paragraph("• <b>Enlace de Acceso:</b> https://pedidos-component.web.app/admin/", bullet_style))
    story.append(Paragraph("• <b>Usuario Administrador:</b> <font face='Courier'>*email@dominio.com* (email con el que se creo la base de datos)</font>", bullet_style))
    story.append(Paragraph("• <b>Contraseña de Seguridad:</b> <font face='Courier'>*contraseña*</font>", bullet_style))
    
    story.append(Paragraph("2.2 Gestión de Catálogo e Inventario", h2_style))
    story.append(Paragraph(
        "El panel de productos permite realizar todas las operaciones de inventario de forma centralizada:",
        body_style
    ))
    story.append(Paragraph("• <b>Creación de Productos:</b> Al hacer clic en 'Agregar Producto', se abre un formulario modal donde se carga el nombre, precio, descripción, categoría, URL de imagen y el <b>Código Interno (SKU)</b>.", bullet_style))
    story.append(Paragraph("• <b>Edición y Borrado:</b> Se pueden actualizar precios y detalles instantáneamente o eliminar productos obsoletos.", bullet_style))
    story.append(Paragraph("• <b>Importación/Exportación Masiva:</b> Permite subir un archivo <b>CSV</b> con cientos de productos a la vez. El archivo CSV debe incluir las siguientes columnas en orden: Nombre, Precio, Foto (URL), Categoria_Id, Descripcion y Codigo (en la sexta columna). El panel lee y carga la información de forma automatizada.", bullet_style))
    
    story.append(Paragraph("2.3 Gestión de Vendedores", h2_style))
    story.append(Paragraph(
        "En la pestaña 'Vendedores' se administran los perfiles de los asesores. Cada vendedor debe estar cargado aquí para poder recibir pedidos de sus clientes:",
        body_style
    ))
    story.append(Paragraph("• <b>Nombre del Vendedor:</b> Nombre que aparecerá en la cabecera de la app del cliente.", bullet_style))
    story.append(Paragraph("• <b>Número de Teléfono:</b> Debe ingresarse con el código de país y código de área, sin espacios ni símbolos (ej. <b>54911********</b> para un número celular de Argentina). De lo contrario, los redireccionamientos de WhatsApp del cliente fallarán.", bullet_style))
    story.append(Paragraph("• <b>Foto de Perfil:</b> URL de la imagen del vendedor, que se recortará en formato circular automáticamente en la app.", bullet_style))
    
    story.append(Paragraph("2.4 Módulo de Enlaces Exclusivos (Tokens de Cliente)", h2_style))
    story.append(Paragraph(
        "Este módulo (pestaña 'Enlaces de Clientes') permite gestionar el sistema de exclusividad vendedor-cliente (Device Locking) si deciden activarlo en el futuro:",
        body_style
    ))
    story.append(Paragraph("1. <b>Generación de Tokens:</b> Escribe el nombre del cliente, selecciona al vendedor asignado en la lista y presiona 'Generar Enlace'. El panel crea un código token único en Firestore.", bullet_style))
    story.append(Paragraph("2. <b>Copiado de Enlace:</b> El portal genera un link con el dominio de producción y el token (ej. <font size='8'>https://pedidos-component.web.app/?vendedorID=id_vend&amp;token=xyz</font>) listo para enviárselo al cliente.", bullet_style))
    story.append(Paragraph("3. <b>Bloqueo en Primer Uso (Lock-on-First-Use):</b> El primer dispositivo (celular) que abre ese link registra su identificador único (UUID). Si el cliente reenvía ese enlace a otra persona, el sistema deniega el acceso al catálogo y muestra una pantalla de bloqueo de enlace exclusivo.", bullet_style))
    story.append(Paragraph("4. <b>Monitoreo y Reinicio:</b> En la lista del panel administrador verás qué dispositivo tiene registrado cada token, su estado ('activo' o 'inactivo') y podrás 'Resetear' el enlace si tu cliente cambia de celular, o 'Eliminar' el acceso permanentemente.", bullet_style))
    
    story.append(Spacer(1, 5))
    story.append(callout_box(
        "<b>Bypass de Seguridad Activo:</b><br/>"
        "Actualmente el sistema de bloqueo por dispositivo se encuentra <b>puenteado (bypass)</b> por solicitud comercial "
        "para evitar carga administrativa excesiva en los vendedores. Esto significa que los clientes pueden ingresar "
        "a la tienda usando los enlaces directos de vendedor sin requerir un token individual. El código y el panel "
        "están totalmente funcionales para reactivar el bloqueo al cambiar una sola variable en el código del frontend."
    ))
    
    # Build the document
    doc.build(story, canvasmaker=NumberedCanvas)

if __name__ == '__main__':
    output_path = r"C:\Users\Ugi Desk\.gemini\antigravity\scratch\app-pedidos-flutterflow\Manual_Usuario_Generico.pdf"
    print(f"Generating PDF at: {output_path}")
    build_pdf(output_path)
    print("PDF Generated successfully!")
