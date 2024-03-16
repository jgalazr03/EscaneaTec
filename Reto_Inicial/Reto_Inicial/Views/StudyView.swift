//
//  StudyView.swift
//  Reto_Inicial
//
//  Created by Mumble on 14/03/24.
//

import SwiftUI

struct StudyView: View {
    var body: some View {
        
        ZStack {
            
            Color(red: 27/255, green: 65/255, blue: 127/255)
            
            HStack {
                
                VStack(alignment: .leading){
                    Text("Neumonía")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Text("La neumonía es una enfermedad del sistema respiratorio caracterizada por la inflamación de los pulmones, específicamente de los pequeños sacos de aire conocidos como alvéolos, donde se produce el intercambio de oxígeno y dióxido de carbono. Esta afección puede ser causada por diferentes agentes, siendo las infecciones bacterianas y virales las más comunes. Los síntomas típicos incluyen fiebre, tos, dificultad para respirar, dolor en el pecho y producción de esputo. La neumonía puede afectar a personas de todas las edades, pero es más grave en los bebés, los adultos mayores y aquellos con sistemas inmunitarios comprometidos. El diagnóstico se realiza a través de la evaluación clínica, pruebas de imagen como radiografías de tórax y análisis de muestras de esputo. El tratamiento varía dependiendo de la causa subyacente y puede incluir antibióticos para infecciones bacterianas, antivirales para infecciones virales y medidas de apoyo como reposo y terapia respiratoria. Es importante buscar atención médica si se sospecha de neumonía, ya que el tratamiento oportuno puede prevenir complicaciones graves y promover una recuperación completa. Además, se recomiendan medidas preventivas como la vacunación contra la gripe y neumococo, el lavado frecuente de manos y evitar el contacto cercano con personas enfermas para reducir el riesgo de contraer neumonía.")
                        .padding()
                    
                        Text("Algunos Síntomas son: Tos persistente, que puede producir esputo verde, amarillo o con sangre. Dificultad para respirar, que puede empeorar al realizar actividades físicas. Dolor en el pecho, que puede agravarse al toser o respirar profundamente. Fiebre alta, generalmente acompañada de escalofríos y sudoración. Fatiga extrema y debilidad.")
                        .padding()
                }
                
                Image("neumonia")
                    .resizable()
                    .frame(width: 300, height: 400)
                    .padding()
                
            }
        }
        
    }
}

#Preview {
    StudyView()
}
